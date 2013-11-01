#encoding: utf-8

class Nexus::PlanInfo < ActiveRecord::Base
  extend  AppHelper
  include NexusBase
  include SoftDeleted
  include ArConstants

  self.table_name = "p_plan_info"
  attr_accessible *column_names

  has_many :programs, class_name: "::Nexus::Program", foreign_key: "plan_info_id"
  belongs_to :target, class_name: "::Nexus::Target", foreign_key: "target_id"
  belongs_to :store, class_name: "::Mp::Store", foreign_key: "store_id"
  belongs_to :mlog, class_name: "::Mp::Mlog", foreign_key: "search_id"
  belongs_to :merchant, class_name: "::Mp::Merchant", foreign_key: "merchant_id"
  belongs_to :mp_plan, class_name: "::Mp::Plan", foreign_key: "mp_plan_info_id"
  belongs_to :creator, class_name: "Mp::Member", foreign_key: "user_id"

  after_save  PlanSeq.new

  def city_name
    store.try(:city_name)
  end

  def merchant_name
    merchant.try(:mch_name)
  end
  
  def crete_by_merchant?
    creator.merchant? #rescue false
  end

  def succ?
    errors.messages.empty? rescue true
  end


  def program_name
    ori_name = read_attribute :program_name
    if ori_name=~/\d{14}$/
      $1
    else
      ori_name
    end
  rescue
    ori_name
  end
  
  def sms_count
    push_number * (target.sms_content.length.to_f/64.to_f).ceil rescue 0
  end

  def mid_list
    _mid_list = nil
    _mid_list = store.store_mid unless store.nil?
    _mid_list = $1 if (mlog.name||"") =~/.*?mid_((_?\d+)*).*/ unless mlog.nil?
    _mid_list || ""
  end

  def mobiles
    (Nexus::TaskUser.where program_id: self.programs.collect(&:program_id)).collect(&:mobile) rescue []
  end

  def plan_type_name
    case plan_type
      when 1
        "主动推送"
      when 2
        "刷卡触发"
      when 3
      when 5
        "个性化"
      when 4
      when 6
        "自定义" #自定义名单
      when 7
        "老客户"
      when 8
        "潜在客户"
      when 9
        "指定商户触发"
      when 10
        "模型触发"
      else
        "未知"
    end
  end

  class<<self
    def save_plan member,config
      create_or_update_program member,config    
      mobiles = (config[:mobiles]||'').split(',')
      if mobiles.nil? || mobiles.empty?
        reset_and_create_task member,config
      else
        #import users
        reset_and_create_task_and_user member,config
      end
      
      reset_and_create_sms_reply config
      #import model and some others
      associate_attachment config
      @plan
    end
    
    def associate_attachment config
      token = config[:token]
      unless token.blank?
        attachment = Attachment.find_by token: token
        attachment.update_attributes ref_id: @plan.id unless attachment.nil?
        
      end
    end
    
    def reset_and_create_task_and_user member,config
      push_time = config[:push_time]
      begin_hour, end_hour =(push_time.is_a?(Array) ? push_time.first : (push_time||'')).split('-')
      
      mobiles = (config[:mobiles]||'').split(',')
      @program.tasks.delete_all

      task = @program.tasks.create begin_date: config[:begin_date], end_date: config[:begin_date], begin_hour: begin_hour,
                                  end_hour: end_hour, task_type: 1, task_status: 0, plan_count: mobiles.length

      Nexus::TaskUser.where(program_id: @program.id).delete_all
      users = []
      mobiles.each do |mobile|
        mobile = (mobile||'').gsub ' ', ''
        users << Nexus::TaskUser.new(target_id: @target.id, program_id: @program.id, mobile: mobile, channel: 1000, task_id: @task.id,
                                     service_id: '005', push_status: 0, push_type: 1, user_id: 0) if mobile=~ /\d{11}/
      end

      Nexus::TaskUser.import users, :validate => false
      @plan.update_attributes push_number: users.length
      @program.update_attributes plan_count: users.length
    rescue => e
      #todo:pending
    end
    
    def create_or_update_program member,config
      program_name = config[:name]||config[:program_name]
      target_config = {sms_content: config[:push_content]}
      #todo:check user type
      store_id = config[:store_id]||member.store_id
      merchant_id = config[:merchant_id]||member.merchant_id
      search_id = search_name = nil
      
      if store_id.present?
        store = Mp::Store.find_by store_id: store_id
        unless store.nil?
          search_id = store.search_id
          merchant_id = store.mch_id
          search_name = store.search_name
        end
      end
      
      plan_config = {store_id: store_id, merchant_id: merchant_id, search_id: search_id, name: program_name, status: 0,
                     city: search_name,plan_category: plan_category(config),plan_type: plan_type(config)}
                     
      program_config = {program_name: program_name, program_status: 0,
                        begin_at: config[:begin_date], end_at: config[:end_date],model_type: model_type(config)}
                        
      if config[:program_id].present?
        @program = Nexus::Program.find config[:program_id]
        @plan = @program.plan
        @target = @plan.target
        
        @target.update_attributes target_config
        @plan.update_attributes plan_config
        @program.update_attributes program_config
      else
        @target = Nexus::Target.create target_config
        @plan = @target.plans.create plan_config.merge({user_id: member.try(:id)})
        @program = @plan.programs.create program_config.merge({program_code: @plan.plan_code, program_type: @plan.plan_type})
      end
      
    end
    
    def reset_and_create_task member,config
      #reset all task
      @program.tasks.delete_all
      
      target_config = {sms_content: config[:push_content]}
      
      push_time = ((config[:push_time]||[]).first ||'').split(',')
      push_end = ((config[:push_end_time]||[]).first ||'').split(',')
      push_date = ((config[:push_date]||[]).first||'').split(',')
      push_number = ((config[:push_number_perday]||[]).first||'').split(',')
      
      push_date.each_with_index do |date, index|
        _push_time = push_time[index]
        puts _push_time
        
        if member.admin?
          begin_hour = _push_time
          end_hour = push_end[index]
        else
          begin_hour, end_hour = (_push_time||'').split('-')
        end
        
        puts begin_hour
        puts end_hour
        
        task =  Nexus::Task.create begin_date: date, end_date: date, begin_hour: begin_hour,program_id: @program.id,
                             end_hour: end_hour, task_type: task_type(config), task_status: 0, plan_count: push_number[index]
      
        Nexus::Target.create target_config.merge(task_id: task.id)
      end

      total_push_number = push_number.inject(0) {|sum, i| sum + i.to_i}
      @plan.update_attributes push_number: total_push_number
      @program.update_attributes plan_count: total_push_number
    end
    
    def reset_and_create_sms_reply config
      @program.replies.delete_all
      
      reply_content = ((config[:reply_content]||[]).first||'').split(',')
      reply_end = config[:reply_end]
      reply_code = ((config[:reply_code]||[]).first||'').split(',')
      
      (reply_code||[]).each_with_index do |code,i|
        @program.replies.create channel: 1000,service_id: '004',up_code: code.upcase,down_content: reply_content[i],begin_time: @program.begin_at,end_time: reply_end
        @program.replies.create channel: 1000,service_id: '005',up_code: code.upcase,down_content: reply_content[i],begin_time: @program.begin_at,end_time: reply_end
      end
    end
    
    def plan_category config
      current_controller_name config
    end
    
    def task_type config
      %w(return new custom personal).include?(current_controller_name(config)) ? 1 : 2
    end
    
    def custome_available? config
       %w(return new custom personal).include?(current_controller_name(config))
    end
    
    def plan_type config
      case  current_controller_name(config)
      when 'personal'
        5
      when 'custom'
        6
      when 'return'
        7
      when 'new'
        8
      when 'merchant'
        9
      when 'model'
        10
      else
        0
      end
    end
    
    def model_type config
      case  current_controller_name(config)
      when 'merchant'
        'pos'
      when 'model'
        'model02'
      else
        'target'
      end
    end
    
    def plan_label config
      PLAN_CATEGORIES[current_controller_name(config).to_sym]
    end
  end
end