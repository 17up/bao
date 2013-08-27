#encoding: utf-8

class Nexus::PlanInfo < ActiveRecord::Base
  include NexusBase
  
  self.table_name = "p_plan_info"
  attr_accessible *column_names
  
  has_many    :programs , class_name: "Nexus::Program",foreign_key: "plan_info_id"
  belongs_to  :target   , class_name: "Nexus::Target" ,foreign_key: "target_id"
  belongs_to  :store    , class_name: "Mp::Store"     ,foreign_key: "store_id"
  belongs_to  :merchant , class_name: "Mp::Merchant"     ,foreign_key: "merchant_id"
  belongs_to  :mp_plan  , class_name: "Mp::Plan"     ,foreign_key:  "mp_plan_info_id"
  
  after_save PlanSeq.new
  
  def city_name
    store.try(:store_city)
  end
  
  def merchant_name
    merchant.try(:mch_name)
  end
  
  def succ?
    errors.messages.empty? rescue true
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
      "自定义" #自定义名单
    else
      "未知"
    end
  end
end