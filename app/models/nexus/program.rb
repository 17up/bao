# coding: utf-8

class Nexus::Program < ActiveRecord::Base
  include NexusBase
  include ProgramConstant
  include SoftDeleted
  include ZhbCategory
  
  self.table_name = "p_program"
  self.primary_key = "program_id"
  
  attr_accessible *column_names

  has_many :reports, class_name: "Nexus::SpReport", foreign_key: "program_id"
  #has_many :replies, class_name: "Nexus::SmsReply", foreign_key: "program_id"
  has_many :tasks, class_name: "Nexus::Task", foreign_key: "program_id"
  has_many :replies, class_name: "Nexus::SmsReply", foreign_key: "program_id"
  has_one :target, class_name: "Nexus::Target", foreign_key: "program_id"
  belongs_to :plan, class_name: "Nexus::PlanInfo", foreign_key: "plan_info_id"
  has_and_belongs_to_many :models, class_name: 'Nexus::Model', join_table: 'p_program_model', foreign_key: 'program_id'

  default_scope { order(created_at: :desc) }

  scope :property, -> { where(program_type: 2) }
  scope :custom, -> { where(program_type: 3) }
  
  before_save :set_program_info
  after_save  SmsCount.new
  
  def send_count
    read_attribute(:send_count).to_f
  rescue 
    0
  end
  
  def plan_sms_count
     plan_count.to_i * (plan.target.sms_content.to_f/64.to_f).ceil
   rescue 
     0
  end
  
  def set_program_info
    self.user_id = plan.try(:user_id)
    self.category_name = plan.try(:creator).try(:category_name)
  end

  def mobiles
    (Nexus::TaskUser.where program_id: program_id).collect(&:mobile)
  end

  def reports_perday
    begin_date = begin_at && begin_at.to_date || 30.days.ago
    end_date = end_at && end_at.to_date || Date.current
    sms = Marketing::Sms.where(program_code: program_code).first
    sms && sms.pushed_count(begin_date, end_date) || []
    Marketing::Sms.where(program_code: program_code).first.pushed_count(begin_date, end_date)
  end


  def reports_by_channel(code)
    self.reports.where(channel: code).where("push_time is not null").count
  end

  def reports_by_date(begin_date, end_date, cate)
    the_reports = cate == "all" ? self.reports : self.reports.send(cate)
    the_reports.where(["push_time > ? AND push_time < ?", begin_date, end_date])
  end

  def number
    plan.push_number||0 rescue 0
  end

  def sms_count
    plan.sms_count||0 rescue 0
  end

  def success_push_number
    reports.success.count
  end

  def market_id
    a = Marketing::Base.where(store_id: plan.store_id, program_code: program_code).first
    a && a.id
  rescue
    nil
  end

  def store_id
    plan.store_id
  end

  def attachment_line_count
    attachment = Attachment.find_by ref_id: plan_info_id
    attachment.count_line unless attachment.nil?
  end

  def personal_line_count
    attachment = Attachment.find_by ref_id: plan_info_id
    file_name = attachment.atta_path
    @lines = IO.readlines(file_name)
    config = JSON.parse(@lines.join(' '))
    GroupProperty.calc_member_count config
  end

  def status
    status_name = STATUS[program_status.to_s]
    status_name = "待发送" if program_status==6 && begin_at && begin_at>Time.now

    {
        name: status_name,
        code: program_status
    }

  end


  def as_json config={}

    rs = replies
    if rs.nil? || rs.empty?
      reply_content = []
      reply_end = ""
      reply_code = []
    else
      rs = rs.where(service_id: '004')
      reply_content = rs.collect(&:down_content)
      reply_end = rs.collect(&:end_time).first
      reply_code = rs.collect(&:up_code)
    end

    {
        program_id: program_id,
        market_id: market_id,
        status: status,
        type: TYPE[model_type.to_s],
        p_type: program_type,
        program_name: program_name,
        created_at: created_at&&created_at.strftime("%Y-%m-%d"),
        push_number: number,
        push_content: plan.try(:target).try(:sms_content),
        sms_count: sms_count,
        push_content: plan.try(:target).try(:sms_content),
        begin_date: begin_at&&begin_at.strftime("%Y-%m-%d"),
        push_number_perday: push_number_perday,
        end_date: end_at&&end_at.strftime("%Y-%m-%d"),
        creator: plan.try(:creator).try(:user_name),
        merchant_name: plan.try(:merchant_name),
        store_id: plan.try(:store_id),
        merchant_id: plan.try(:merchant_id),
        reply_content: reply_content,
        reply_end: reply_end,
        reply_code: reply_code,
        report_effect: report_effect,
        report_execute: report_execute,
        tasks: tasks
    }
  end
  
  def report_effect
    if plan.crete_by_merchant? && %w{4 6}.include?(program_type.to_s)
      false
    else
      true
    end
    #todo:add rescue
    #
  rescue => e
    false
  end
  
  def report_execute
    true
  end

  def push_number_perday
    tasks.collect(&:plan_count) rescue []
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

  def as_full_json config={}
    begin_date = begin_at && begin_at.to_date || 30.days.ago
    end_date = end_at && end_at.to_date || Date.current
    sms = Marketing::Sms.where(program_code: program_code).first
    chart_data = sms && sms.pushed_count(begin_date, end_date) || []
    status = STATUS[program_status.to_s]

    {
        status: status,
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

  alias as_short_json as_json
  alias as_show_json as_json

  class << self
    def filter_by_name(name)
      self.where(["program_name like (?)", "%#{name}%"])
    end

    def filter_by_date(bd, ed)
      self.joins(:tasks).where(["begin_date > ? AND end_date < ?", bd, ed])
    end

    # 成功推送条数 success
    # 已推送条数 pushed
    # 共计划发送条数 all
    def reports_count_by_date(programs, begin_date, end_date, cate = "success")
      programs.collect { |x|
        x.reports_by_date(begin_date, end_date, cate).count
      }.sum
    end

    # 24小时统计
    def reports_group_by(programs, begin_date, end_date)
      list = (0..23).to_a.inject({}) { |a, x| a.merge({x => 0}) }
      data = programs.inject({}) { |a, x|
        a.merge(x.reports_by_date(begin_date, end_date, "success").group("hour(push_time)").count)
      }
      list.merge(data)
    end

    def list config={}
      plan_category = config.delete(:plan_category)||0

      instance = self.new
      config.each do |key, value|
        config.delete key.to_sym unless instance.respond_to? key.to_sym
      end

      programs = Nexus::Program.includes(:replies, :plan, plan: [:target, :store, :merchant, :creator]).where(config)

      if plan_category.to_i>0
        filter_plan =  Nexus::PlanInfo.where('plan_category is not null')
        programs = programs.where('plan_info_id in (?)',filter_plan.collect(&:id))
      end
       #      
      # if merchant_flag.to_i >0
      #   filter_category = 
      # end
      # 
      # if merchant_flag.to_i > 0
      #   
      # end

      programs
    end

    def list_by_member_id current_member
      self.where program_id: Mp::MemberPlan.where(member_id: current_member.id).collect(&:plan_id)
    end
  end
end
