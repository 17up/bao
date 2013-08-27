# coding: utf-8
class Nexus::SpReport < ActiveRecord::Base
  include NexusBase
	
	self.table_name = "p_task_user"
	attr_accessible :task_id,
					:user_id, 
					:target_id,
					:program_id, # 方案号
					:sms_content, 
					:mobile,
					:channel, # 发送通道
					:service_id, # 扩展码					
					:push_status, # 发送状态
					:push_type, #0 主动发送。 1刷卡触发
					:push_time,
					:succ_time,
					:seq_id, 
					:msg_id,
					:tran
	belongs_to :program,:class_name => "Nexus::Program",:foreign_key => "program_id"

	PER_PAGE = 10

	PUSH_TYPE = {
		"1" => "主动发送",
		"2" => "刷卡触发",
		"3" => "msite"
	}
	PUSH_STATUS = {
		"0" => "等待发送",#STATUS_WAITING
		"2" => "发送等待反馈",#STATUS_SENDING
		"4" => "发送成功",#STATUS_SUCCESS
		"11" => "一天的发送量已满",#STATUS_DAY_FULL
		"13" => "一个周期内的发送量已满",#STATUS_ALL_FULL
		"9" => "发送失败"#STATUS_FAILED
	}
	CHANNEL_CODE = {
		"0000" => "UNIONPAY_95516",
		"0002" => "UNIONPAY_LONGNUMBER",
		"1000" => "UMP_API",
		"1001" => "UMP_FTP",
		"2000" => "MKL",
		"3000" => "CS"
	}
	paginates_per PER_PAGE
	scope :failed, -> {where(["push_status in (?)",[9,11,13]])}
	scope :pushed, -> { where("push_time is not null")}
	scope :success, -> { where(push_status: 4)}


	class << self
		def default_begin_date
			Date.today - 30.days
		end

		def default_end_date
			Date.today
		end

		# 执行报告汇总
		def reports_detail_by(plans,begin_date,end_date)
			self.success.joins(:program).where(["push_time > ? AND push_time < ?",begin_date,end_date]).where(["program_code in (?)",plans])
		end

		def generate_csv_by(program)
			CSV.generate do |csv|
    			# header row
    			csv << ["方案号", "方案名称", "手机号", "发送时间", "成功时间", "发送方式", "发送状态", "短信文案", "发送通道", "扩展码"]  			
    			program.reports.order("push_time desc").each do |sp|
    				csv << sp.as_csv(program.program_name)
    			end
			end
		end
	end

	def format_push_time
		push_time ? push_time.strftime("%Y-%m-%d %H:%M:%S") : "-"
	end

	def format_succ_time
		succ_time ? succ_time.strftime("%Y-%m-%d %H:%M:%S") : "-"
	end

	def format_push_status
		PUSH_STATUS[push_status.to_s]
	end

	def format_push_type
		PUSH_TYPE[push_type.to_s]
	end

	def format_channel_code
		CHANNEL_CODE[channel.to_s]
	end

	def format_mobile
		#mobile[0..2] + "****" + mobile[7..10]
    "*******" + mobile[7..10]
	end

	def as_json
		ext = {
			push_time: format_push_time,
			succ_time: format_succ_time,
			push_type: format_push_type,
			push_status: format_push_status,
			channel: format_channel_code,
			program_id: program.program_code,
			program_name: program.program_name,
			mobile: format_mobile
		}
		super().merge!(ext)
	end

	def as_csv(plan_name)
		[program.program_code,plan_name,mobile,format_push_time,format_succ_time,format_push_type,format_push_status,sms_content,format_channel_code,service_id]
	end

end