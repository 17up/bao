#encoding: utf-8

class Mp::Store < ActiveRecord::Base
  self.table_name = '_store_info'
  self.primary_key = 'store_id'
  
  include SoftDeleted
  include ArConstants
  
  attr_accessible *column_names
      
  belongs_to :merchant, class_name: "Mp::Merchant",foreign_key:  "mch_id"
  belongs_to :city
  
  has_many :store_costs,class_name: "Mp::StoreCost",foreign_key:  "store_id"
  has_many :plans,class_name: "Mp::Plan",foreign_key:  "store_id"
  has_many :member_stores
  has_many :members, through: :member_stores
  has_many :plan_infos,class_name: 'Nexus::PlanInfo',foreign_key: 'store_id'
  
  validates :store_name, presence: true, uniqueness: {scope: :mch_id}
  
  delegate :name, to: :merchant, prefix: true, allow_nil: true

  before_save :set_city_info
  after_save  :update_log_info
  
  def merchant_id
    mch_id
  end
  
  def city_name
    store_city =~ /^\d+$/ ? City.find(store_city).city_ch_name : store_city# if city_id.present?
  rescue => e
    store_city
  end
  
  def programs config={}
    Nexus::Program.list config.merge({plan_info_id: plan_infos.collect(&:id)})
  end

  def price_status
    ar = price_stat.strip.split("_").map{|x| x.split(":")}.sort!{|a,b| a[0].to_i <=> b[0].to_i}
    more = ar.shift
    ar << more
    ar.compact
  end

  def set_city_info
    self.status = 0
    self.update_time = Time.current
    
    if store_city.present? && store_city.to_i!=-1
      city = City.find store_city
      self.search_name = city.city_name.split.first.downcase unless city.nil?
    end
  end
  
  def store_mid=(mid)
    write_attribute :store_mid,trim(mid).split(' ').join('_')
  end
  
  def store_tid=(tid)
    write_attribute :store_tid,trim(tid).split(' ').join('_') rescue ''
  end
  
  def update_log_info
    log_info = Mp::Mlog.find_by store_id: id
    
    config = {name: mid_and_tid,city: search_name,store_id: id}
    
    if log_info.present?
      log_info.update_attributes config
    else
      log_info = Mp::Mlog.create config
    end
    
    self.update_attributes search_id: log_info.id if search_id.blank?
  end
  
  def mid_and_tid
    "mid_#{store_mid}_tid_#{store_tid}"
  end
  
  def status_name
    STORE_STATUS[read_attribute(:status).to_s]
  end
  
  def trim s
    (s||"").gsub("\r\n",' ').gsub("\n",' ').gsub("\r",' ').gsub("\t",' ').gsub(',',' ').gsub(';',' ').gsub(':',' ').gsub("|",' ')
  rescue => e
    s||''
  end
  
  def store_mid_html
    (store_mid||'').gsub('_',",")
  end
  
  def store_tid_html
    (store_tid||'').gsub '_',","
  end
end
