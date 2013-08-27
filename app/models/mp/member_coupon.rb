#coding: utf-8
class Mp::MemberCoupon < ActiveRecord::Base
 	attr_accessible :book_count, 
  				  	:cp_id, 
  				  	:cp_view_count, 
	  				:cp_push_count, 
	  				:weixin_follow_count,  				
	  				:weibo_follow_count, 
	  				:tel_count, 
	  				:member_id
	belongs_to :member

	CAN_VISIT = {
		cp_view_count: "view",
		cp_push_count: "cellphone",
		weixin_follow_count: "weixin",
		weibo_follow_count: "weibo",
		book_count: "reservation",
		tel_count: "phonecall"
	}


	def open?
		cp_view_count||cp_push_count||weixin_follow_count||weibo_follow_count||book_count||tel_count
	end

	def as_json_by_date(begin_date,end_date)
		s = {}
		as_json().select{|k,v| v == true}.map do |k,v| 
			s.merge!(k => 
				{
					num: Activity::ClickTrackingLog.by_category_and_date(cp_id,CAN_VISIT[k.to_sym],begin_date,end_date).count,
					cn_name: I18n.t("member_coupon.#{k}")
				})
		end
		s
	end

	def as_json_group_by(begin_date,end_date)
		s = {}
		as_json().select{|k,v| v == true}.map do |k,v|
			s.merge!(k => Activity::ClickTrackingLog.group_by_day(cp_id,CAN_VISIT[k.to_sym],begin_date,end_date)) 
		end
		s
	end

end
