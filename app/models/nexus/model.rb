#encoding: utf-8

class Nexus::Model < ActiveRecord::Base
  include NexusBase
	self.table_name = "p_model"

  attr_accessible *column_names
  
	has_and_belongs_to_many :programs,class_name: 'Nexus::Program',join_table: 'p_program_model',foreign_key: 'model_id'
end