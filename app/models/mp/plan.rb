#coding: utf-8
class Mp::Plan < ActiveRecord::Base
	self.table_name = "_plan_info"
	attr_accessible :active_begin, 
					:active_end, 
					:active_nw_num, 
					:active_nw_num_per_day, 
					:active_rt_num, 
					:active_rt_num_per_day, 
					:active_sms, 
					:active_time, 
					:channel, 
					:city, 
					:plan_id, 
					:plan_name, 
					:search_id, 
					:state, 
					:submit_time, 
					:test_mobile, 
					:trigger_begin, 
					:trigger_mch_method, 
					:trigger_mch_num, 
					:trigger_num, 
					:trigger_sms, 
					:trigger_user_method,
					:plan_type,
					:store_id,
					:trigger_count_per_day,
					:trigger_hour_per_day

	belongs_to :store,:class_name => "Mp::Store",:foreign_key => "store_id"
	belongs_to :report,:class_name => "Mp::Report",:foreign_key => "plan_id"

	before_create :set_default
	STATUS = {
		:default => "待审核",
		:passed => "审核通过",
		:unpass => "审核不通过"
	}

	def set_default
		self.state = STATUS[:default]
		self.submit_time = Time.current
		self.channel = 1
		self.city = self.store.search_name
		self.search_id = self.store.search_id
		self.plan_id = "default_" + self.store_id.to_s + "_#{Time.now.to_i}_#{self.plan_type}" 
	end
	
	def as_short_json
		ext = {
			"status" => state,
			"merchant_name" => "example",
			"apply_account" => "veggie",
			"active_begin" => active_begin.strftime("%Y-%m-%d"),
			"active_end" => active_end.strftime("%Y-%m-%d")
		}
		as_json(:only => [:plan_name,:active_sms,:trigger_sms]).merge!(ext)
	end

end
