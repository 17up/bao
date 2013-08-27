#encoding: utf-8

class Nexus::Pos < ActiveRecord::Base
  include NexusBase
  
	self.table_name = "m_pos"

	attr_accessible :merchant_id,:terminal_id,:mid

	belongs_to :merchant, :class_name => "Nexus::Merchant",:foreign_key => "merchant_id"
end