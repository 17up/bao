#coding: utf-8
class Mp::Report < ActiveRecord::Base
	self.table_name = "report2_info"

	attr_accessible :report_id,
					:program_name, #方案名称
					:name, #报表名称
					:mid_tid, 
					:operate_time, #操作时间
					:operate_account, #操作账户
					:begin_time,
					:end_time,
					:before_count, #推送前一周刷卡总量
					:before_gain, #推送前一周成交金额
					:after_count, #推送期刷卡总量
					:after_gain, #推送期成交金额
					:status
	before_create :preset
	has_many :report_perdays,:class_name => "Mp::ReportPerday",:foreign_key => "report_id"
	has_many :report_convs,:class_name => "Mp::ReportConv",:foreign_key => "report_id"

	STATUS = {
		"0" => "未完成",
		"1" => "完成"
	}
	def preset
		self.operate_time = Time.current
		self.status = 0
	end

	def as_json
		ext = {
			"begin_time" => begin_time.strftime("%Y-%m-%d"),
			"end_time" => end_time.strftime("%Y-%m-%d"),
			"status" => STATUS[status.to_s],
			"operate_time" => operate_time.strftime("%Y-%m-%d")
		}
		super().merge!(ext)
	end

	def detail
		perdays = report_perdays.as_json
		all_count = perdays.collect{|x| x["all_count"]}.compact.sum
		all_gain = perdays.collect{|x| x["all_gain"]}.compact.sum
		push_count = perdays.collect{|x| x["push_count"]}.compact.sum
		push_gain = perdays.collect{|x| x["push_gain"]}.compact.sum

		perdays_sum = {
			all_count: all_count,
			all_gain: all_gain,
			push_count: push_count,
			push_gain: push_gain,
			count_percent: (all_count != 0) && (push_count.to_f/all_count).round(2),
			gain_percent: (all_gain != 0) && (push_gain.to_f/all_gain).round(2)
		}

		push_summary = {
			before: [
				before_count,
				before_gain,
				(before_gain.to_f/before_count).round(2),
				(before_count.to_f/7).round(2),
				(before_gain.to_f/7).round(2)
			],
			after: [
				after_count,
				after_gain,
				(after_gain.to_f/after_count).round(2),
				(after_count.to_f/7).round(2),
				(after_gain.to_f/7).round(2)
			]
		}
		{
			program_name: program_name,
			perdays: perdays,
			perdays_sum: perdays_sum,
			convs: report_convs.limit(Mp::ReportConv::PER_PAGE).as_json,
			push_summary: push_summary,
			page_info: Mp::ReportConv.page_info(self,1)
		}	
	end

end