# coding: utf-8
class Mp::ReportPerday < ActiveRecord::Base
	self.table_name = "report_info_perday"
	attr_accessible :report_id,
					:mid_tid,
					:day, #日期
					:all_count, #刷卡次数
					:all_gain, #交易金额
					:push_count, #推送刷卡次数
					:push_gain, #推送成交金额
					:return_push_count, #回头客推送数量
					:return_push_count_sus, #回头客推送成交笔数
					:return_push_gain_sus, #回头客成交金额
					:new_push_count, #目标新客户推送数量
					:new_push_count_sus, #目标新客户推送成交笔数
					:new_push_gain_sus, #目标新客户成交金额
					:trigger_push_count, #刷卡触发推送数量
					:trigger_push_count_sus, #刷卡触发推送成交笔数
					:trigger_push_gain_sus, #刷卡触发成交金额
					:msite_push_count, #个性化推送数量
					:msite_push_count_sus, #个性化推送成交笔数
					:msite_push_gain_sus #个性化成交金额
	belongs_to :report,:class_name => "Mp::Report",:foreign_key => "report_id"

	def as_json

		ext = {
			count_percent: (all_count != 0) &&(push_count.to_f/all_count).round(2),
			gain_percent: (all_gain != 0) && (push_gain.to_f/all_gain).round(2)
		}

		super().merge!(ext)
	end
end