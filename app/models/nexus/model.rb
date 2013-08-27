#encoding: utf-8

class Nexus::Model < ActiveRecord::Base
  include NexusBase
  
	self.table_name = "p_model"

	attr_accessible :model_id,:model_name,:intercept,:weight2,:weight4,:weight7,:path2,:path4,:path_user7,:path_merchant7,:score_threshold,:f4_threshold

	has_and_belongs_to_many :programs,class_name: 'Nexus::Program',join_table: 'p_program_model',foreign_key: 'model_id'
end