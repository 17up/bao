#encoding: utf-8

class Mp::Member < ActiveRecord::Base
  include  AppHelper
  include  AuthenticationConcern
  include  SoftDeleted
  include  ArConstants
  include  ZhbCategory
  include  PlanOps::Member

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable#, :validatable
  belongs_to :m_role, :class_name => "Mp::Role", :foreign_key => "role"
  has_many :member_stores
  has_many :stores, :through => :member_stores
  has_many :member_plans, :class_name => "::Mp::MemberPlan", :foreign_key => "member_id"
  has_one :member_coupon
  has_many :name_lists, class_name: 'Mp::NameList', foreign_key: 'user_id'

  validates :user_name,:password,presence: true
  validates :user_name,length: { minimum: 3 },uniqueness: { case_sensitive: false}
  validates :password ,length: { in: 6..20 }

  belongs_to :merchant
  belongs_to :agent, foreign_key: 'merchant_id'
  belongs_to :store

  attr_accessible *column_names, :login, :password

  def user_label
    upsmart? ? user_name : store.nil? ? user_name : store.store_name
  end

  def display_result_page?
    member_coupon && member_coupon.open?
  end

  def change_password config
    self.update_attributes password: config[:password]
  end

  def plan_category config
    current_controller_name config
  end

  def create_program plan, config
    plan.programs.create program_name: plan.name, program_code: plan.plan_code, program_status: 0, model_type: config[:model_type],
                         program_type: plan.plan_type, begin_at: config[:begin_date], end_at: config[:end_date], model_type: config[:model_type]||'target'
  end

  def create_name_list config={}
    name_list = Mp::NameList.create name: config[:name], user_id: self.id, merchant_id: self.merchant_id, store_id: self.store_id

    (config[:mobiles]||'').split(',').each do |mobile|
      name_list.name_mobiles.create mobile: mobile if mobile=~ /\d{11}/
    end

    name_list
  end

  def programs config={}
    if upsmart?
      Nexus::Program.list.page(config[:page]||1).per(10)
    elsif merchant?
      config[:category_name] = 'merchant' if config[:category_name].blank?
      store.programs(config).page(config[:page]||1).per(10)
    else
      store.programs(config).page(config[:page]||1).per(10)
    end

  rescue => e
    []
  end

  def union_programs config={}
    member_plans.includes(:program, program: [:plan]).page(config[:page]||1)
  end
  
  def city_name
    city_id = store.try(:store_city)
    city_id =~ /^\d+$/ ? City.find(city_id).city_ch_name : city_id if city_id.present?

  rescue => e
    city_id
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

  def category
    MEMBER_CATEGORIES[category_name.to_sym]
  end
end