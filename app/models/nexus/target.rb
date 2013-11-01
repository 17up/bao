#encoding: utf-8

class Nexus::Target < ActiveRecord::Base
  include NexusBase
  
  self.table_name = "p_target"
  self.primary_key = "target_id"
  
  attr_accessible *column_names

  belongs_to :program,:class_name => "Nexus::Program",:foreign_key => "program_id"
  has_many :plans,:class_name => "Nexus::PlanInfo",:foreign_key => "target_id"
  
  before_save :set_default_values
  
  def set_default_values
    if service_id.blank?
      self.sms_var_num = 0
      self.service_id = "004"
      self.sms_signature = "【惠享生活】"
    else
      #get signature
    end
  end
  
  def sms_content=(content)
    write_attribute :sms_content,trim(content)
  end
end