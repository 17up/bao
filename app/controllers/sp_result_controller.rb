class SpResultController < ApplicationController

	def summary
		filter_by_date(params[:begin_date],params[:end_date])
		programs = current_member.programs

		gains = Mp::ReportConv.group_by_date(current_member.mid,current_member.tid,@begin_date,@end_date)
		if gains.any?
			p gain_hash = gains.group("date(push_time)").count
		end

		mc = current_member.member_coupon.as_json_by_date(@begin_date,@end_date)
		success_number = Nexus::Program.reports_count_by_date(programs,@begin_date,@end_date)	
		push_number_hash = Nexus::SpReport.reports_detail_by(programs,@begin_date,@end_date).group("date(push_time)").count
		cp_hash = current_member.member_coupon.as_json_group_by(@begin_date,@end_date)
		detail = (@begin_date...@end_date + 1.day).to_a.inject([]) do |a,x|
			t = {
				date: x,
				push_count: push_number_hash[x] || 0	
			}
			Mp::MemberCoupon::CAN_VISIT.map{|k,v| k.to_s}.each do |y|
				if cp_hash[y]
					t = t.merge(y.to_sym => cp_hash[y][x] || 0)
				end
			end
			if gain_hash
				t.merge!(:gain_count => gain_hash[x] || 0)
			end
			a << t
		end

		data = {
			push_number: success_number,
			gain_number: gains.count,
			mc: mc,
			detail: detail
		}
		render_json 0,"ok",data
	end

	def chart
		filter_by_date(params[:begin_date],params[:end_date])
		cate = params[:cate] || "cp_view_count"
		
		data = {
			number: Activity::ClickTrackingLog.count_group_by(current_member.member_coupon.cp_id,Mp::MemberCoupon::CAN_VISIT[cate.to_sym],@begin_date,@end_date).map{|k,v| v},
			cn_name: I18n.t("member_coupon.#{cate}"),
			tip_name: I18n.t("member_coupon.tip.#{cate}")
			}
		render_json 0,"ok",data	
	end

	private

	def filter_by_date(bd,ed)
		@begin_date = bd.present? ? Date.parse(bd) : Nexus::SpReport.default_begin_date
		@end_date  = ed.present? ? Date.parse(ed) : Nexus::SpReport.default_end_date
	end

end