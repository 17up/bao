#encoding: utf-8

class Nexus::Merchant < ActiveRecord::Base
  include NexusBase
  
	self.table_name = "m_merchant"
	self.primary_key = "merchant_id"

	attr_accessible :parent_id,:merchant_name,:logo,:address,:phone,:bussiness_hours,:comments,:merchant_status

	has_many :poses,class_name: 'Nexus::Pos',foreign_key: 'merchant_id'
end