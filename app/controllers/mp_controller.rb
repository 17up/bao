class MpController < ApplicationController

	def consume
		@store = current_member.stores.any? ? current_member.stores.first : Mp::Store.find(5)
		ac30 = consume_sum(30)
		
		price_range = @store.price_status.map{|x| x[0]}
		price_allcnt = @store.price_status.map{|x| x[1].to_i}.sum
		price_cnt = @store.price_status.map{|x| (x[1].to_f*100/price_allcnt).round(2) }
	  	data = {	  		
			:consume => ac30[0],  
			:sum => ac30[1],					
			:date => ac30[2],
			:rc7 => consume_sum(7)[1],
	  		:store_name => @store.log_info,
	  		:price_range => price_range,
	  		:price_cnt => price_cnt
	  	}
	  	render_json 0,"ok",data
	end

	def app_visit
		data = {
	  		:visit => (200..370).to_a.sample(30),
	  		:favorite => (100..170).to_a.sample(30)
	  	}
	  	render_json 0,"ok",data
	end

	def preview_plan
		@store = current_member.stores.any? ? current_member.stores.first : Mp::Store.find(5)
		if true#@store.status == 1
			prefix = @store.search_name + "_" + @store.search_id.to_s
			number = params[:number].to_i
			days = (Time.parse(params[:active_end]) - Time.parse(params[:active_begin]))/(24*3600)
			begin
				# return
				table_name = "#{prefix}_return_customer"
				Mp::Customer.connect(table_name)
				r_cnt = Mp::Customer.count
				stc = @store.trigger_count.scan(/7_/).any? ? @store.trigger_count.split("_")[1] : 0
				c1 = days*stc.to_i
				trigger = (c1 < number*0.3 ? c1 : number*0.3).to_i
				active = number - trigger
				retu = (r_cnt < active*0.3 ? r_cnt : active*0.3).to_i
				newu = active - retu

			rescue => ex 
				render_json -9,"error: #{ex.message}"
			end
			data = {
				:trigger => trigger,
				:active => active,
				:retu => retu,
				:newu => newu
			}
			render_json 0,"ok",data
		else
			render_json -1,"fail"
		end
	end

	#@store_id
	#@number
	#@active_begin @active_end
	def save_plan
		@store = current_member.stores.any? ? current_member.stores.first : Mp::Store.find(6)

		active_common = params.slice(:plan_name,:active_begin,:active_end)
		days = (Time.parse(params[:active_end]) - Time.parse(params[:active_begin]))/(24*3600)
		active_p = @store.plans.new active_common
		active_p.active_sms = params[:content]
		active_p.active_rt_num = params[:active_rt_num]
		active_p.active_nw_num = params[:active_nw_num]
		active_p.active_nw_num_per_day = join_items(days,(params[:active_nw_num].to_i/days).round) 
		active_p.active_rt_num_per_day = join_items(days,(params[:active_rt_num].to_i/days).round)
		active_p.active_time = join_items(days,12)
		active_p.plan_type = 0
		
		trigger_p = @store.plans.new active_common
		trigger_p.trigger_begin = params[:active_begin]
		trigger_p.trigger_num = params[:trigger_num]
		trigger_p.trigger_sms = params[:content]
		trigger_p.trigger_mch_num = 100
		trigger_p.trigger_count_per_day = join_items(days,(params[:trigger_num].to_i/days).round)
		trigger_p.trigger_hour_per_day = join_items(days,12)
		trigger_p.plan_type = 1
		
		if active_p.save && trigger_p.save
			render_json 0,"ok"
		else
			p trigger_p.errors.messages
			render_json -1,"error"
		end
	end

	def plan_list		
		@store = current_member.stores.any? ? current_member.stores.first : Mp::Store.find(6)
		data = combine_plans2(@store.plans).reverse
		render_json 0,"ok",data
	end

	def report_list
		@store = current_member.stores.any? ? current_member.stores.first : Mp::Store.find(6)
		plans_with_report = @store.plans.joins("right join _report_info t1 ON t1.plan_id = _plan_info.plan_id ").all
		data = combine_plans2(plans_with_report,true)

		render_json 0,"ok",data
	end

	# @id
	def report
		@report = Mp::Report.find(params[:id])
		render_json 0,"ok",@report.as_json
	end

	private
	def join_items(count,item)
		count.to_i.times.inject([]){|a,t| a << item}.join(",")
	end

	def consume_sum(time_range)
		t = (Time.current - time_range.days + 13.hours).strftime("%Y-%m-%d")
		sc = @store.store_costs.where(["day >= ?",t])
		consume = sc.collect{|x| x.gain}
		date = sc.collect{|x| x.day}
		return consume,consume.sum,date
	end

	def combine_plans2(plans,report = false)
		plans.group_by(&:plan_name).map do |k,v|
			pn = k ? k.split("_") : []
			pn.pop
			number_proc =->(v) {v.active_rt_num.to_i + v.active_nw_num.to_i + v.trigger_num.to_i}
			max_proc =->(vs,a) { vs.collect{|x| x.send(a).to_i}.max }
			if v.length > 1
				number = number_proc.call(v[0]) + number_proc.call(v[1])
				trigger_num = max_proc.call(v,"trigger_num")
				active_rt_num = max_proc.call(v,"active_rt_num")
				active_nw_num = max_proc.call(v,"active_nw_num")
			else
				number = number_proc.call(v[0])
				trigger_num = v[0].trigger_num.to_i
				active_rt_num = v[0].active_rt_num.to_i
				active_nw_num = v[0].active_nw_num.to_i
			end
			active_end = report ? v[0].active_end + 1.day : v[0].active_end
			{
				:plan_name => pn.join(),
				:number => number,
				:active_begin => v[0].active_begin.strftime("%Y-%m-%d"),
				:active_end => active_end.strftime("%Y-%m-%d"),
				:submit_time => v[0].submit_time.strftime("%Y-%m-%d"),
				:status => v[0].state,
				:trigger_num => trigger_num,
				:active_rt_num => active_rt_num,
				:active_nw_num => active_nw_num,
				:content => v[0].active_sms || v[0].trigger_sms,
				:plan_id => v[0].plan_id
			}
		end
	end
  
end
