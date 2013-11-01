# coding: utf-8

class Nexus::SmsReply < ActiveRecord::Base
  include NexusBase

  self.table_name = "sms_reply"
  attr_accessible *column_names
  
  default_scope {where("#{self.table_name}.status=0")}
  

  def begin_time
    read_attribute(:begin_time).try :to_s, :db
  end

  def end_time
    read_attribute(:end_time).try :to_s, :db
  end

  def as_json config={}
    super(:only => [:up_code, :down_content, :begin_time, :end_time])
  end

  class<<self
    def available?(code, config)
      program_id = config[:program_id]
      begin_date = config[:begin_date]
      if program_id.blank?
        self.where('up_code= ? and end_time>=?', code.upcase,begin_date).first.nil?
      else
        self.where('up_code= ? and program_id!=? and  end_time>=?', code.upcase, program_id, begin_date).first.nil?
      end
    end
  end
end