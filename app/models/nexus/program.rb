# coding: utf-8

class Nexus::Program < ActiveRecord::Base
  include NexusBase
  
  self.table_name = "p_program"
  
  include ProgramConstant

  PER_PAGE = 20
  paginates_per PER_PAGE
  
  attr_accessible :program_code, :program_name, :program_status, :model_type, :program_type, :begin_at, :end_at,
                  :interval_time, :channel, :per_1, :per_2, :created_at
                  
  has_many :reports, :class_name => "Nexus::SpReport",:foreign_key => "program_id"
  has_many :tasks, :class_name => "Nexus::Task",:foreign_key => "program_id"
  has_one  :target, :class_name => "Nexus::Target",:foreign_key => "program_id"
  belongs_to :plan, :class_name => "Nexus::PlanInfo", :foreign_key => "plan_info_id"

  has_and_belongs_to_many :models,class_name: 'Nexus::Model',join_table: 'p_program_model',foreign_key: 'program_id'

  scope :property, -> {where(program_type: 2)}
  scope :custom, -> {where(program_type: 3)}

  # To-DO
  # 小瑞提供
  def reports_perday
    begin_date =  begin_at && begin_at.strftime("%Y-%m-%d") || Date.parse('2013-08-01')
    end_date = end_at && end_at.strftime("%Y-%m-%d") || Date.parse('2013-11-01')
    sms = Marketing::Sms.where(program_code: program_code).first
    sms && sms.pushed_count(begin_date, end_date) || []
    Marketing::Sms.where(program_code: program_code).first.pushed_count(begin_date, end_date)
  end


  def reports_by_channel(code)
    self.reports.where(channel: code).where("push_time is not null").count
  end

  def reports_by_date(begin_date,end_date,cate)
    the_reports = cate == "all" ? self.reports : self.reports.send(cate)
    the_reports.where(["push_time > ? AND push_time < ?",begin_date,end_date])
  end

  def number
    a = []
    a << per_1.split(",") if per_1
    a << per_2.split(",") if per_2 
    a.flatten.map(&:to_i).sum
  end

  def success_push_number
    reports.success.count
  end

  def market_id
    a = Marketing::Base.where(store_id: plan.store_id,program_code: program_code).first
    a && a.id
  end

  def as_short_json
    {
      program_id: program_id,
      market_id: market_id,
      status: STATUS[program_status.to_s],
      type: TYPE[model_type.to_s],
      p_type: program_type,
      program_name: program_name,
      created_at: created_at&&created_at.strftime("%Y-%m-%d"),
      push_number: number,
      begin_date: begin_at&&begin_at.strftime("%Y-%m-%d"),
      end_date: end_at&&end_at.strftime("%Y-%m-%d"),
      push_content: plan.target.try(:sms_content)
    }
  end

  def wait_days
    if end_at 
      days = (end_at.to_date - Date.today).to_i
      days > 0 ? days : 0
    else
      0
    end
  end

  def program_name
    ori_program_name = read_attribute :program_name
    if ori_program_name =~ /_\d{13}/
      pname = ori_program_name.split("_")
      pname[0...pname.length-1].join("_")
    else
      ori_program_name
    end
  rescue => e
    ori_program_name
  end

  def as_full_json
    begin_date =  begin_at && begin_at.strftime("%Y-%m-%d") || Date.parse('2013-08-01')
    end_date = end_at && end_at.strftime("%Y-%m-%d") || Date.parse('2013-11-01')
    sms = Marketing::Sms.where(program_code: program_code).first
    chart_data = sms && sms.pushed_count(begin_date, end_date) || []
    {
      status: STATUS[program_status.to_s],
      type: TYPE[model_type.to_s],
      plan_name: program_name,
      begin_date: begin_date,
      end_date: end_date,
      number: number,
      success_number: chart_data.sum,
      wait_days: wait_days,
      chart_data: chart_data
    }
  end
  
  class << self
    def filter_by_name(name)
      self.where(["program_name like (?)","%#{name}%"])
    end

    def filter_by_date(bd,ed)
      self.joins(:tasks).where(["begin_date > ? AND end_date < ?",bd,ed])
    end

    # 成功推送条数 success
    # 已推送条数 pushed
    # 共计划发送条数 all
    def reports_count_by_date(programs,begin_date,end_date,cate = "success")
      programs.collect{|x| 
        x.reports_by_date(begin_date,end_date,cate).count
      }.sum
    end

    # 24小时统计
    def reports_group_by(programs,begin_date,end_date)
      list = (0..23).to_a.inject({}){|a,x| a.merge({x =>  0})}
      data = programs.inject({}){|a,x| 
        a.merge(x.reports_by_date(begin_date,end_date,"success").group("hour(push_time)").count)
      }
      list.merge(data)
    end

    def list config={}
      page = config.delete(:page)||1
      per_page = config.delete(:per_page)||25
      instance = self.new
      config.each do |key,value|
        config.delete key.to_sym  unless instance.respond_to? key.to_sym          
      end
      Nexus::Program.where(config)#.page(page)#.per(per_page)
    end
  end  
end