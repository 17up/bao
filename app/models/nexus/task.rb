#encoding: utf-8

class Nexus::Task < ActiveRecord::Base
  include NexusBase
  
  self.table_name = "p_task"
  self.primary_key = "task_id"

  attr_accessible *column_names
  
  belongs_to 	:program,:class_name => "Nexus::Program",:foreign_key => "program_id"
  has_many 	:users, :class_name => "Nexus::TaskUser",:foreign_key => "task_id"
  has_one :target, class_name: "Nexus::Target", foreign_key: 'task_id'

  def begin_hour
    read_attribute(:begin_hour).try :strftime,'%H:%M:%S'
  end
  
  def end_hour
    read_attribute(:end_hour).try :strftime,'%H:%M:%S'
  end
end