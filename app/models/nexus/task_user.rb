#encoding: utf-8

class Nexus::TaskUser < ActiveRecord::Base
  include NexusBase
  
	self.table_name = "p_task_user"

	attr_accessible :task_id,:target_id,:program_id,:mobile,:channel,:service_id,:push_type,:push_status,:p_task_user,:plan_count,:user_id

	belongs_to :program,class_name: "Nexus::Program",foreign_key: "program_id"
	belongs_to :task,	class_name: "Nexus::Task",	 foreign_key: "task_id"
	belongs_to :target,	class_name: "Nexus::Target", foreign_key: "target_id"

end