#encoding: utf-8
require 'yaml'

class PlanWorker
  attr_accessor :r

  include Sidekiq::Worker

  include CmdHelper
  include Properties
  include HttpHelper

  def perform(plan_info_id)
    puts "worker:#{r}"
    return if r.nil?

    @plan = Nexus::PlanInfo.find_by_plan_code r.plan_id
    @program = Nexus::Program.find_by_program_code r.plan_id
    puts "sync:#{r.plan_id},#{r.state}"
    if r.state == '2' && @program.program_status <= 2
      puts "begin"
      #todo:reset @program
      
      @merchant = Nexus::Merchant.create
      @plan.update_attributes merchant_id: @merchant.id
      load_merchant
      
      @program.update_attributes program_status: 2
      
      begin
        #根据MID模型数据
        if r.plan_type == 0
          unless r.search_id.blank?
            copy_to_nexus "new"
            copy_to_nexus "return"
          end
          #根据特征文件
        elsif r.plan_type == 1
          load_task_file
          #指定用户列表
        elsif r.plan_type == 2
          if r.channel ==1
            #发送全部通道
            copy_to_nexus "user", 2
            copy_to_nexus "user", 3
          else
            copy_to_nexus "user"
          end
        end
        @program.update_attributes program_status: 3
        puts "program_status:#{@program.program_status}"
        
        #if @program.program_status==2 #||  @program.program_status==-1
          #r.update_column 'state', '3'
          
        begin
          
          post_nexus "checkProgram", @program.program_code
            #r.update_column 'state', '4'            
        rescue => e
          puts "sync to nexus error:#{e.inspect}"
          #@program.update_attributes program_status: -2
            #r.update_column 'state','5'
          raise e
        end
          
          #end
      rescue => e
        puts e.inspect
        #@program.update_attributes program_status: -1
        raise e
      end
    # elsif r.state == '5'
  #     puts "just sync nexus"
  #     begin
  #       post_nexus "checkProgram", @program.program_code
  #       #r.update_column 'state', '4'
  #       @program.update_attributes program_status: 3
  #     rescue => e
  #       puts "sync to nexus error:#{e.inspect}"
  #       #r.update_column 'state', '5'
  #       raise e
  #     end 
    end

  end

  def copy_to_nexus category, channel=r.channel
    puts "copy_to_nexus:#{category},#{channel}"
    begin_date = r.active_begin
    active_times = r.active_time.split(',')

    total_num = 0
    category_per_day(category, channel).split(',').each_with_index do |num, index|
      task = @program.tasks.create! begin_date: begin_date, begin_hour: format_hour(active_times[index]), task_type: r.task_type, task_status: r.task_status, plan_count: num
      begin_date+=1.day
      target = task.create_target task_id: task.id, plan_count: num, sms_content: r.active_sms

      customers = get_customers category, num, total_num, channel
      break if customers.empty?
      users = []
      
      customers.each do |c|
        user = Nexus::TaskUser.new target_id: target.id, program_id: @program.id, mobile: (c||"").gsub("U", ""), channel: channel_from_mobile(c), task_id: task.id,
                                   service_id: service_type_from_mobile(@program,c), push_status: 0, push_type: r.push_type, user_id: 0, user_type: user_type_from_cateogry(category)
        users << user
      end

      Nexus::TaskUser.import users, :validate => false

      break if begin_date > r.active_end
      total_num += num.to_i
    end
  end

  #end copy_to_nexus

  def get_customers category, num, total_num, channel=r.channel
    if %w{new return}.include?(category)
      customer_instance = Mp::Customer.new

      Mp::Customer.connect "#{r.city}_#{r.search_id}_#{category}_customer"

      customers = Mp::Customer.order("#{category=='new' ? 'sim' : 'count'} desc")

      if channel == 2 #ump
        if  customer_instance.respond_to?(:customer_type)
          customers = customers.where(customer_type: 1)
        else
          customers = customers.where(" mobile like 'U%' ")
        end

      elsif channel == 3 #upop
        if  customer_instance.respond_to?(:customer_type)
          customers = customers.where(customer_type: 0)
        else
          customers = customers.where(" mobile not like 'U%' ")
        end
      end

      customers = customers.limit(num.to_i).offset(total_num.to_i).collect(&:mobile)

    elsif category == 'user'
      if channel == 2
        customers = r.customize_user.split.select { |c| c =~ /^U/i }
      elsif channel == 3
        customers = r.customize_user.split.select { |c| c =~ /^\d/ }
      else
        customers = r.customize_user.split
      end

      customers[total_num ... total_num + num.to_i]||[]
    end
  end

  def category_per_day category, channel=r.channel
    #每日UMP推送人数
    #active_rt_num_per_day
    column = nil
    #每日UPOP推送人数
    #active_nw_num_per_day
    if %w{new return}.include?(category)
      column = "active_#{category=='new' ? 'nw' : 'rt'}_num_per_day"
    elsif category == 'user'
      if channel == 2
        column = "active_rt_num_per_day"
      elsif channel == 3
        column = "active_nw_num_per_day"
      else
        raise "invalid channel:#{channel}"
      end
    end


    puts "category_per_day:#{column},#{r.send column.to_sym}"
    r.send column.to_sym
  end

  def format_hour hour
    hour
  end

  def load_task_file
    property_file = "#{HADOOP_DATA_DIR}/#{r.city_name}/#{r.city_name}_model_weight"
    puts "property file:#{property_file}"
    load_properties property_file
    intercept = get_property 'Intercept'
    f2_weight = get_property 'f2_mid'
    f4_weight = get_property 'f4_mid'
    f7_weight = get_property 'f7_mid'
    f4_threshold = get_property 'f4_threshold'
    score_threshold = get_property 'score_threshold'

    
    @model = Nexus::Model.find_by_model_name r.city

    if @model.nil?
      @program.models.create model_name: r.city_name, intercept: intercept, weight2: f2_weight, weight4: f4_weight, weight7: f7_weight,
                             score_threshold: score_threshold, f4_threshold: f4_threshold
    else
      puts @model.programs.collect(&:program_id)
      puts @program.id
      @model.programs << @program unless @model.programs.collect(&:program_id).include?(@program.id)
    end

    active_times = r.trigger_hour_per_day.split(',')
    begin_date = r.active_begin

    r.trigger_count_per_day.split(',').each_with_index do |num, index|
      puts '*'*100
      task = @program.tasks.create begin_date: begin_date, begin_hour: format_hour(active_times[index]),
                                   task_type: r.task_type, task_status: r.task_status, plan_count: num,
                                   end_date: begin_date, end_hour: "22:00"
      @program.create_target task_id: task.id, plan_count: num, sms_content: r.sms_content, merchant_id: @merchant.id

      begin_date+=1.day

      break if begin_date > r.active_end.to_datetime
    end

    
    #load_trigger
  end


  def load_merchant
    r.mid_list.split("_").each do |mid|
      @merchant.poses.create mid: trim(mid) unless mid.blank?
    end
  end

  def trim content
    content.gsub("\n", "").gsub(" ", "")
  end

  def user_type_from_mobile m
    m=~/^U/ ? 1 : 2
  end
  
  def user_type_from_cateogry c
    case c
    when 'new'
      1
    when 'return'
      2
    else
      0
    end
  end

  def service_type_from_mobile p,m
    m=~/^U/ ? "004" : "005"
  end
  
  def channel_from_mobile m
    m=~/^U/ ? "1000" : "2000"
  end
end