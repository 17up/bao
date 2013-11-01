class window.SmartMerchant.AppPushView extends SmartMerchant.ResultView
	id: "app_push"
	template: JST['mp/app_push']
	weidian: true
	render_detail: (detail) ->
		$("#sp_detail .sp_container").html JST['mp/item/app_result_detail'](collection: detail)
	render_summary: (json) ->
		$("#sp_summary .sp_container").html JST['mp/sp_result/summary2'](json)
		bg_date = json.begin_date.split("-")
		$("#chart1",@$el).highcharts @setup_chart(json.chart_data.exposure,bg_date,"曝光","曝光次数分布")
		$("#chart2",@$el).highcharts @setup_chart(json.chart_data.attention.follows,bg_date,"关注","关注次数分布")
		$("#chart3",@$el).highcharts @setup_chart(json.chart_data.tick_count,bg_date,"成交笔数","成交转化笔数分布","笔")
		$("#chart4",@$el).highcharts @setup_chart(json.chart_data.tick_amount,bg_date,"成交金额","成交转化金额分布","元")
