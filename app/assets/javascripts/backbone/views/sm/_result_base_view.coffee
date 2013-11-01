class window.SmartMerchant.ResultView extends SmartMerchant.View
	model: new SpResult()
	begin_date: ""
	end_date: ""
	events:
		"changeDate input[name='begin_date']": "change_begin_date"
		"changeDate input[name='end_date']": "change_end_date"
		"ajax:success #sp_result_summary": "update_summary"
		"click #return_manage": "return_manage"
		"click .export": "export"
		"click a.summary": "resize"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		if @mod_id
			request_url = "/marketings/#{@mod_id}/detail"
		else if @weidian
			request_url = "/marketings/weidian_detail"
		else
			request_url = "/marketings/summary"
		@$el.html @template(request_url: request_url)
		@model.fetch
			url: request_url
			success: (data) =>
				@render_summary(data.toJSON())
				@render_detail(data.get("daily_data"))
				@render_time_select(data.get("begin_date"),data.get("end_date"))
		@get_conv()
		@get_attention()
		this
	render_time_select: (bd,ed) ->
		$("#sp_result_summary").append JST['mp/widget/begin_end_date'](begin_date: bd,end_date: ed)
		datetime_options =
			format: 'yyyy-mm-dd'
			language: "zh-CN"
			minView: 'month'
			autoclose: true
			# startDate: $.date().adjust("D", -30).date()
			# endDate: $.date().adjust("D", -1).date()
		$(".date input").datetimepicker datetime_options
	paginate: (e,data) ->
		href = $(e.currentTarget).attr "href"
		if href.match(/follow/)
			$("#tab-2 .sp_container").html JST['mp/item/sp_attention_detail'](data.data)
		else
			$("#tab-3 .sp_container").html JST['mp/item/sp_conv_detail'](data.data)
	resize: ->
		setTimeout( ->
			$(window).resize()
		,500)

	return_manage: ->
		window.route.navigate("manage_list",true)
	update_summary: (e,data) ->
		@render_summary(data.data)
		@render_detail(data.data.daily_data)
		$form = $(e.currentTarget)
		@begin_date = $("input[name='begin_date']",$form).val()
		@end_date = $("input[name='end_date']",$form).val()
		@get_conv()
		@get_attention()
	render_detail: (detail) ->
		$("#sp_detail .sp_container").html JST['mp/item/sp_result_detail'](collection: detail)
	render_summary: (json) ->
		$("#sp_summary .sp_container").html JST['mp/sp_result/summary2'](json)
		bg_date = json.begin_date.split("-")
		$("#chart1",@$el).highcharts @setup_chart(json.chart_data.exposure,bg_date,"曝光","曝光次数分布")

		if json.chart_data.attention.clicked_count
			$("#chart2",@$el).highcharts @setup_chart2(json.chart_data.attention,bg_date,["回复","点击"],"关注次数分布",["点击链接次数","回复短信次数"])
		else
			$("#chart2",@$el).highcharts @setup_chart(json.chart_data.attention,bg_date,"关注","关注次数分布")
		$("#chart3",@$el).highcharts @setup_chart(json.chart_data.tick_count,bg_date,"成交笔数","成交转化笔数分布","笔")
		$("#chart4",@$el).highcharts @setup_chart(json.chart_data.tick_amount,bg_date,"成交金额","成交转化金额分布","元")
	change_begin_date: (e) ->
		$dt = $("input[name='end_date']").data("datetimepicker")
		$dt.setStartDate e.date
		$form = $(e.currentTarget).closest("form")
		$form.submit()
	change_end_date: (e) ->
		$("input[name='begin_date']").data("datetimepicker").setEndDate e.date
		$form = $(e.currentTarget).closest("form")
		$form.submit()
	export: ->
		this
	get_attention: (e) ->
		params =
			begin_date: @begin_date
			end_date: @end_date
		request_url = "/marketings/follows"
		if @mod_id
			request_url = "/marketings/#{@mod_id}/follow"
		else if @weidian
			request_url = "/marketings/weidian_follow"
		$.get request_url,params,(data) ->
			$("#tab-2 .sp_container").html JST['mp/item/sp_attention_detail'](data.data)
		this
	get_conv: (e) ->
		params =
			begin_date: @begin_date
			end_date: @end_date
		request_url = "/marketings/convs"
		if @mod_id
			request_url = "/marketings/#{@mod_id}/conv"
		else if @weidian
			request_url = "/marketings/weidian_conv"
		$.get request_url,params,(data) ->
			$("#tab-3 .sp_container").html JST['mp/item/sp_conv_detail'](data.data)
		this
	setup_chart: (data,bg_date,tip_name,title,per = "次") ->
		chart_params =
			exporting:
				enabled: false
			chart:
				type: "spline"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 80
				height: 400
				backgroundColor: "#fff"
			credits:
      			enabled: false
			title:
				text: title
			xAxis:
				type: 'datetime'
				#tickInterval: 24 * 3600 * 1000
				# title:
				# 	text: "xx"
				# 	margin: 20
				labels:
					formatter: ->
						Highcharts.dateFormat("%m/%d", this.value, false)
			yAxis:
				min: 0
				title:
					text: ""
					margin: 20
			plotOptions:
				spline:
					fillColor: null
					fillOpacity: 0
					marker:
						fillColor: '#FFFFFF'
						lineWidth: 2
						lineColor: null
			tooltip:
				animation: true
				style:
					fontSize: '14px'
					padding: 8
				shared: true
				xDateFormat: "%Y-%m-%d"
				valueSuffix: per
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			legend:
				enabled: false
			series:[
				name: tip_name
				pointInterval: 24 * 3600 * 1000
				pointStart: Date.UTC(Number(bg_date[0]), parseFloat(bg_date[1]) - 1, Number(bg_date[2]))
				data: data
			]
		return chart_params
	setup_chart2: (data,bg_date,tip_name_array,title,subtitle_array,per = "次") ->
		c1 =
			name: subtitle_array[0]
			pointInterval: 24 * 3600 * 1000
			pointStart: Date.UTC(Number(bg_date[0]), Number(bg_date[1]) - 1, Number(bg_date[2]))
			data: data.clicked_count
		c2 =
			name: subtitle_array[1]
			pointInterval: 24 * 3600 * 1000
			pointStart: Date.UTC(Number(bg_date[0]), Number(bg_date[1]) - 1, Number(bg_date[2]))
			data: data.reply_count
			color: "#e74c3c"
		chart_params =
			exporting:
				enabled: false
			chart:
				type: "spline"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 80
				height: 400
				backgroundColor: "#fff"
			credits:
      			enabled: false
			title:
				text: title
			xAxis:
				type: 'datetime'
				#tickInterval: 24 * 3600 * 1000
				# title:
				# 	text: "xx"
				# 	margin: 20
				labels:
					formatter: ->
						Highcharts.dateFormat("%m/%d", this.value, false)
			yAxis:
				title:
					text: ""
					margin: 20
			plotOptions:
				spline:
					fillColor: null
					fillOpacity: 0
					marker:
						fillColor: '#FFFFFF'
						lineWidth: 2
						lineColor: null
			tooltip:
				animation: true
				style:
					fontSize: '14px'
					padding: 8
				shared: true
				xDateFormat: "%Y-%m-%d"
				valueSuffix: per
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			legend:
				enabled: true
				layout: "vertical"
				align: "right"
				verticalAlign: 'top'
				floating: true
				borderWidth: 0
			series: [c1,c2]
		return chart_params

