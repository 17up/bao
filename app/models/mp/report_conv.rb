# coding: utf-8
class Mp::ReportConv < ActiveRecord::Base
	self.table_name = "_report_conv_info"
	attr_accessible :report_id,
					:program_code, #方案号
					:mid_tid,
					:mobile, #手机号
					:mobile_zone, #ump/upop
					:push_time, #推送时间
					:push_type, #推送方式是否为回头客/目标新客户/刷卡触发/个性化
					:channel, #发送通道
					:service_id, #扩展码
					:pri_acct_no, #主账号
					:trans_id, #交易代码
					:mchnt_tp, #商户类型
					:acpt_ins_id_cd, #受理机构代码
					:iss_ins_id_c, #发卡机构代码
					:cups_card_in, #是否银联标准卡
					:cups_sig_card_in, #是否银联标识卡
					:card_class, #卡种
					:card_cata, #卡类别
					:card_attr, #卡性质
					:card_brand, #卡品牌
					:card_prod, #卡产品
					:card_lvl, #卡等级
					:trans_chnl, #交易渠道
					:trans_media, #交易介质
					:trans_at, #交易金额
					:trans_rcv_ts #交易接收时间戳

	belongs_to :report,:class_name => "Mp::Report",:foreign_key => "report_id"

	PER_PAGE = 100
	paginates_per PER_PAGE

	PUSH_TYPE = {
		"1" => "主动发送",
		"2" => "刷卡触发",
		"3" => "msite"
	}
	CHANNEL_CODE = {
		"0000" => "UNIONPAY_95516",
		"0002" => "UNIONPAY_LONGNUMBER",
		"1000" => "UMP_API",
		"1001" => "UMP_FTP",
		"2000" => "MKL",
		"3000" => "CS"
	}

	class << self
		def page_info(report,page)
			pages = report.report_convs.count%PER_PAGE == 0 ? report.report_convs.count/PER_PAGE : (report.report_convs.count/PER_PAGE + 1)
			{
				pages: pages,
				page: page,
				next: page.to_i < pages,
				prev: page.to_i > 1
			}
		end

		def group_by_date(mid,tid,begin_date,end_date)
			begin
				mid_reg = mid.split(",").join("|")
				tid_reg = tid.split(",").join("|")
				self.where(["push_time > ? AND push_time < ?",begin_date,end_date]).where(["mid_tid REGEXP ?","#{mid_reg + tid_reg}"])
			rescue
				[]
			end
		end

	end

	def as_json
		if mid_tid
			a = mid_tid.split("tid")
			mid = a[0].split("_")
			mid.shift
			mid = mid.join(",")
			if a[1]
				tid = a[1].split("_") 
				tid.shift
				tid = tid.join(",")
			end
		end
		ext = {
			push_time: (push_time.strftime("%Y-%m-%d %H:%M:%S") if push_time),
			trans_rcv_ts: (trans_rcv_ts.strftime("%Y-%m-%d %H:%M:%S") if trans_rcv_ts),
			push_type: PUSH_TYPE[push_type.to_s],
			mid: mid,
			tid: tid,
			channel: CHANNEL_CODE[channel.to_s]
		}
		super().merge!(ext)
	end

end