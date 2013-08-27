#encoding: utf-8

class Nexus::Task < ActiveRecord::Base
  include NexusBase
  
	
	self.table_name = "p_task"
	self.primary_key = "task_id"

	attr_accessible :program_id,:begin_date,:end_date,:begin_hour,:end_hour,:task_type,:task_status,:plan_count,:sms_content

	belongs_to 	:program,:class_name => "Nexus::Program",:foreign_key => "program_id"
	has_many 	:users, :class_name => "Nexus::TaskUser",:foreign_key => "task_id"

end