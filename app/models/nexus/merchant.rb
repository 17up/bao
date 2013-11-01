#encoding: utf-8

class Nexus::Merchant < ActiveRecord::Base
  include NexusBase

  self.table_name = "m_merchant"
  self.primary_key = "merchant_id"

  attr_accessible *column_names
  
  has_many :poses,class_name: 'Nexus::Pos',foreign_key: 'merchant_id'
end