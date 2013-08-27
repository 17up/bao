#encoding: utf-8

class Mp::Member < ActiveRecord::Base
  include AuthenticationConcern

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # attr_accessible :email, :password, :password_confirmation, :remember_me, :role, :user_name, :mid, :tid,:user_name,:mobile
  belongs_to :m_role, :class_name => "Mp::Role", :foreign_key => "role"
  has_many :member_stores
  has_many :stores, :through => :member_stores
  has_many :member_plans, :class_name => "::Mp::MemberPlan", :foreign_key => "member_id"
  has_one :member_coupon

  belongs_to :merchant
  belongs_to :store

  def is_admin?
    role == 3
  end

  def display_result_page?
    member_coupon && member_coupon.open?
  end

  def create_plan config = {}
    push_time = (config[:push_time].first ||'').split(',')
    push_date = (config[:push_date].first||'').split(',')
    push_number = (config[:push_number_perday].first||'').split(',')

    target = Nexus::Target.create sms_content: config[:push_content]

    plan = target.plans.create store_id: store_id, merchant_id: merchant_id, name: config[:name], status: 0, city: city,
                               plan_type: config[:plan_type]
    program =plan.programs.create program_name: plan.name, program_code: plan.plan_code, program_status: 0, model_type: config[:model_type],
                                  program_type: config[:program_type], begin_at: config[:begin_date], end_at: config[:end_date]

    push_date.each_with_index do |date, index|
      begin_hour, end_hour = (push_time[index]||'').split('-')
      program.tasks.create begin_date: date, end_date: date, begin_hour: begin_hour,
                           end_hour: end_hour, task_type: 1, task_status: 0, plan_count: push_number[index]
    end
    
    plan
  end

  def programs config={}
    (
    if merchant?
    else
      store.try(:programs, config)
    end
    )|| [] rescue []
  end

  def agent?
    false
  end

  def merchant?
    false
  end

  def store?
    true
  end

  def city_name
    store.try(:store_city)
  end

  def city
    store.try(:search_name)
  end

  def as_json
    ext = {
        :role => m_role.as_json,
        :created_at => created_at.strftime("%Y-%m-%d"),
        :stores => stores.collect(&:log_info).join(",")
    }
    super(:only => [:id, :email, :user_name, :mid, :tid, :mobile, :merchant_id, :store_id]).merge(ext)
  end

end
