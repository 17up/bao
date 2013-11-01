#encoding: utf-8
class Agent < ActiveRecord::Base
  self.table_name = '_mch_info'
  self.primary_key = 'mch_id'
  
  include ArConstants
  include AuditAble

  attr_accessible *column_names

  default_scope {where("_mch_info.deleted_at is null and _mch_info.agent=1")}    
  
  has_one :first_account,->{order('id asc').limit(1)}, class_name: "Mp::Member", foreign_key: "merchant_id"
  belongs_to :city
  belongs_to :category,class_name: 'MerchantCategory'
  has_many :merchants,class_name: 'Mp::Merchant'
  validates :mch_name, presence: true, uniqueness: true
  
  class<<self
    def search config={}
      agent = Agent.order(created_at: :desc)
      agent = agent.where('mch_name like ?',"%#{config[:mch_name]}%") if config[:mch_name].present?
      agent.page(config[:page]||1)
    end
    
    def save_agent member,config={}
      @agent = nil
      @id = config[:id]
      
      @agent = Agent.find(@id) if @id.present?
      
      agent_config = {mch_name: config[:mch_name],category_id: config[:category_id],mch_info: config[:mch_info],
                    mch_phone: config[:tel],company_name: config[:company_name],creator_id: member.try(:id),status: 'approve',
                    category_name: member.try(:category_name),agent_id: member.try(:merchant_id),city_id: config[:city_id],
                    agent: true,package_begin: config[:begin_at],package_end: config[:end_at],address: config[:address]}
    
      if @agent.nil?             
        @agent = Agent.create agent_config
      else
        @agent.update_attributes agent_config
      end
      
      @agent      
    end
    
  end
  

  def stores
    merchants.order(mch_id: :desc).includes(:first_account,:package).limit(10).map{|m| m.as_list_json}
  end
  
  def bind_account member,config={}
    reset_account

    Mp::Member.create category_name: 'agent',merchant_id: self.id,
                      user_name: config[:mch_account],password: config[:password],creator_id: member.try(:id),enable_zhb: true
  end
  
  def reset_account
    Mp::Member.where(merchant_id: self.id).delete_all
  end
  
  
  def as_list_json config={}
    account_name = first_account.try(:user_name)

    {
      id:id,
      name: mch_name,
      account_name: account_name,
      freezed: freeze_status,
      created_at: created_at.try(:to_s,:simple)
    }
  end
  
  def as_json config={}
    {
      id: id,
      mch_name: mch_name,
      account_name: first_account.try(:user_name),
      account_id: first_account.try(:id),
      city_id: city.try(:id),
      city_name: city.try(:city_ch_name),
      parent_city_id: city.try(:parent_id),
      parent_category_id: category.try(:parent_id),
      category_id: category.try(:id),
      category_name: category.try(:name_path),
      mch_info: mch_info,
      company_name: company_name,
      address: address,
      begin_at: package_begin.try(:to_s,:simple),
      end_at: package_end.try(:to_s,:simple),
      tel: mch_phone
    }
  end
end
