#encoding: utf-8

class Mp::Store < ActiveRecord::Base
  self.table_name = "_store_info"
  attr_accessible :store_name, :store_address, :store_province, :store_city, :store_region, :store_mid, :store_tid, :store_info, 
      :store_phone, :store_label, :store_cost, :store_taste, :store_enviroment, :store_service, :store_time, :store_air, 
      :store_feature, :search_id, :search_name, :trigger_count, :status, :price_stat,:update_time
      
  belongs_to :merchant, class_name: "Mp::Merchant",foreign_key:  "mch_id"
  has_many :store_costs,class_name: "Mp::StoreCost",foreign_key:  "store_id"
  has_many :plans,class_name: "Mp::Plan",foreign_key:  "store_id"
  has_many :member_stores
  has_many :members, through: :member_stores

  has_many :plan_infos,class_name: 'Nexus::PlanInfo',foreign_key: 'store_id'
  
  validates :store_name, presence: true, uniqueness: {scope: :mch_id}

  before_save :preset
  after_save :insert_log
  
  def programs config={}
    Nexus::Program.list config.merge({plan_info_id: plan_infos.collect(&:id)})
  end

  def preset
    self.status = 0
    self.update_time = Time.current
  end

  def log_info
    self.merchant.mch_name + " " + self.store_name
  end

  def log_name
    name = ""
    if self.store_mid.present?			
      name += ("mid_" + self.store_mid)
    end
    if self.store_tid.present?
      name += ("_tid_" + self.store_tid)
    end
    name
  end

  def insert_log
    unless search_id
      mlog = Mp::Mlog.create(
      :info => self.log_info,
      :name => self.log_name
      )
      self.search_id = mlog.id
      self.search_name = "shanghai_" + mlog.id.to_s
      self.save
    end
  end

  def price_status
    ar = price_stat.strip.split("_").map{|x| x.split(":")}.sort!{|a,b| a[0].to_i <=> b[0].to_i}
    more = ar.shift
    ar << more
    ar.compact
  end

  def as_short_json
    ext = {
      :update_time => update_time.strftime("%Y-%m-%d"),
      :mch_name => merchant.mch_name
    }
    as_json(:only => [:store_id,:store_name,:store_address,:store_mid,:store_tid,:store_info]).merge!(ext)
  end
  
end
