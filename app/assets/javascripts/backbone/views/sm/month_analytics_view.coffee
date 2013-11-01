class window.SmartMerchant.MonthAnalyticsView extends SmartMerchant.View
	id: "month_analytics"
	template: JST['mp/month_analytics']
	model: new MonthAnaly()
	begin_date: ""
	end_date: ""
	events:
		"click a.tab-link": "trigger_tab"
		"click .filter_by_day": "filter_by_day"
		"click .filter_by_hour": "filter_by_hour"
		"changeDate input[name='begin_date']": "change_begin_date"
		"changeDate input[name='end_date']": "change_end_date"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		@$el.html @template()
		$.get "/operates/check",(data) =>
			@render_time_select(data.data.begin_date)
			if data.data.valid
				@render_r1()
			else
				$(".main-container").html  "<div class='alert alert-warning'>您统计的交易区间内没有交易数据</div>"
		this

	fetch_tab: (href)->
		switch href
			when "#tab-1"
				@render_r1()
			when "#tab-2"
				@render_r2()
			when "#tab-3"
				@render_r3()
			when "#tab-4"
				@render_r4()
		setTimeout( ->
			$(window).resize()
		,500)
	trigger_tab: (e) ->
		$target = $(e.currentTarget)
		@fetch_tab $target.attr "href"
	update_summary: ->
		$form = $("#sp_result_summary")
		@begin_date = $("input[name='begin_date']",$form).val()
		@end_date = $("input[name='end_date']",$form).val()
		href = $(".tabbable li.active a.tab-link").attr "href"
		$(".tab-content .tab-pane").removeClass 'loaded'
		@fetch_tab href
	render_time_select: (begin_date) ->
		@limitStartDate = $.date(begin_date.earliest,"yyyy-MM").date()
		@limitEndDate = $.date().adjust("M", -1).date()
		ed_str = $.date().adjust("M", -1).format("yyyy-MM")
		$("#sp_result_summary").append JST['mp/widget/begin_end_date'](begin_date: begin_date.current,end_date: ed_str,month: true)
		datetime_options =
			format: 'yyyy-mm'
			language: "zh-CN"
			startView: 'year'
			minView: 'year'
			autoclose: true
			# startDate: $.date(begin_date.current,"yyyy-MM").date()
			startDate: @limitStartDate
			endDate: @limitEndDate
		$(".date input").datetimepicker datetime_options

	filter_by_day: (e) ->
		$target = $(e.currentTarget)
		$target.addClass('active').siblings().removeClass("active")
		json = @model.toJSON()
		if $target.attr("rel") is 'chart'
			@render_charts(json.daily,json.begin_date.split("-"))
		else
			@render_detail(json.daily.statis)
	filter_by_hour: (e) ->
		$target = $(e.currentTarget)
		$target.addClass('active').siblings().removeClass("active")
		json = @model.toJSON()
		if $target.attr("rel") is 'chart'
			@render_charts(json.period,false)
		else
			@render_detail(json.period.statis)
	reset_filter: ->
		$(".filter_by_day").addClass 'active'
		$(".filter_by_hour").removeClass 'active'
	render_summary: (json) ->
		$("#r1_summary").html JST['mp/month_analytics/summary'](json)
		@reset_filter()
		@render_charts(json.daily,json.begin_date.split("-"))
	render_charts: (data,bg_date) ->
		$("#chart1",@$el).highcharts @setup_chart(data.tick_count,bg_date,"笔数","成交笔数","笔")
		$("#chart2",@$el).highcharts @setup_chart(data.tick_people,bg_date,"人数","成交人数","人")
		$("#chart3",@$el).highcharts @setup_chart(data.tick_amount,bg_date,"金额","成交金额","元")
		$("#chart4",@$el).highcharts @setup_chart(data.tick_per,bg_date,"客单价","客单价","元")
	render_detail: (detail) ->
		$("#r1_detail").html JST['mp/month_analytics/table_1'](collection: detail)
	common_date_change: (e,is_start = true) ->
		if is_start
			$dt = $("input[name='end_date']").data("datetimepicker")
			$dt.setStartDate e.date
			endDate = $.date($(e.currentTarget).val(),"yyyy-MM").adjust("M", +2).date()
			date = if endDate < @limitEndDate then endDate else @limitEndDate
			$dt.setEndDate date
		else
			$dt = $("input[name='begin_date']").data("datetimepicker")
			$dt.setEndDate e.date
			startDate = $.date($(e.currentTarget).val(),"yyyy-MM").adjust("M", -2).date()
			date = if startDate > @limitStartDate then startDate else @limitStartDate
			$dt.setStartDate date
		$.get "/operates/check",(data) =>
			if data.data.valid
				@update_summary()
			else
				$(".main-container").html  "<div class='alert alert-warning'>您统计的交易区间内没有交易数据</div>"
	change_begin_date: (e) ->
		@common_date_change(e)
	change_end_date: (e) ->
		@common_date_change(e,false)

	render_r1: ->
		unless $("#tab-1").hasClass 'loaded'
			$loader = Utils.loading2 $("#tab-1")
			request_url = "/operates/overview?begin_date=#{@begin_date}&end_date=#{@end_date}"
			@model.fetch
				url: request_url
				success: (data) =>
					$("#tab-1").addClass 'loaded'
					@render_summary(data.toJSON())
					@render_detail(data.toJSON().daily.statis)
					$loader.remove()
	render_r2: (e) ->
		unless $("#tab-2").hasClass 'loaded'
			$loader = Utils.loading2 $("#tab-2")
			params =
				begin_date: @begin_date
				end_date: @end_date
			request_url = "/operates/dealrecord"
			$.get request_url,params,(data) =>
				$("#tab-2").addClass 'loaded'
				cates = data.data.tick_dist.name
				cdata = data.data.tick_dist.data
				$("#chart5",@$el).highcharts @setup_chart2(cdata,cates)
				$("#r2_tick_freq").html JST['mp/month_analytics/table_2'](collection: data.data.tick_freq)
				$loader.remove()
		this
	render_r3: ->
		unless $("#tab-3").hasClass 'loaded'
			$loader = Utils.loading2 $("#tab-3")
			params =
				begin_date: @begin_date
				end_date: @end_date
			request_url = "/operates/feature"
			$.get request_url,params,(data) =>
				$("#tab-3").addClass 'loaded'
				$("#chart6 .chart_content").html JST['mp/month_analytics/sex_chart'](sd: data.data.gender_dist)
				$("#chart7",@$el).highcharts @setup_chart4(data.data.ability_dist[1],data.data.ability_dist[0],"消费","消费能力分布","人")
				$("#chart8",@$el).highcharts @setup_chart4(data.data.intensity_dist,false,"强度","消费强度分布","人")
				$("#chart10",@$el).highcharts @setup_chart4(data.data.tag_dist[1],data.data.tag_dist[0],"标签","消费偏好分布","%")
				$("#chart9",@$el).highcharts @setup_chart6(data.data.level_dist)
				$loader.remove()
	render_r4: ->
		unless $("#tab-4").hasClass 'loaded'
			$loader = Utils.loading2 $("#tab-4")
			params =
				begin_date: @begin_date
				end_date: @end_date
			request_url = "/operates/dealflow"
			$.get request_url,params,(data) =>
				$("#tab-4").addClass 'loaded'
				$("#tab-4 .sp_container").html JST['mp/month_analytics/report_4'](data.data)
				$loader.remove()
		this
	paginate: (e,data) ->
		$("#tab-4 .sp_container").html JST['mp/month_analytics/report_4'](data.data)
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
				offset: 20
				#tickInterval: 24 * 3600 * 1000
				title:
					text: ""
					margin: 20
				labels:
					formatter: ->
						Highcharts.dateFormat("%m/%d", this.value, false)
			yAxis:
				min: 0
				allowDecimals: false
				title:
					text: ""
					margin: 20
			plotOptions:
				spline:
					fillColor: null
					fillOpacity: 0
					marker:
						fillColor: '#FFFFFF'
						radius: 2
						lineWidth: 1
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
				pointStart: Date.UTC(Number(bg_date[0]), Number(bg_date[1]) - 1, Number(bg_date[2]))
				data: data
			]
		if bg_date is false
			series =
				xAxis:
					type: 'datetime'
					labels:
						formatter: ->
							Highcharts.dateFormat("%H:%M", this.value, false)
				tooltip:
					animation: true
					style:
						fontSize: '14px'
						padding: 8
					shared: true
					xDateFormat: "%H:%M"
					valueSuffix: per
					headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
				series:[
					name: tip_name
					pointInterval: 3600 * 1000
					data: data
				]
			return _.extend chart_params,series
		else
			return chart_params
	setup_chart2: (data,cates) ->
		chart_params =
			exporting:
				enabled: false
			chart:
				type: "column"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 25
				height: 400
				backgroundColor: "#f9f9f9"
				# width: 'auto'
			credits:
				enabled: false
			title:
				text: ""
			xAxis:
				categories: cates
			yAxis:
				title:
					text: "笔数"
					margin: 20
			tooltip:
				animation: true
				style:
					fontSize: '14px'
					padding: 8
				shared: true
				valueSuffix: "笔"
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			legend:
				enabled: false
			series:[
				name: '笔数'
				data: data
			]
		return chart_params
	setup_chart4: (data,cates,tip_name,title,per) ->
		unless cates
			cates = _.map data,(e,i) ->
				if i is 9
					"10次及以上"
				else
					"#{i + 1}次"
		chart_params =
			exporting:
				enabled: false
			chart:
				type: "column"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 25
				height: 250
				backgroundColor: "#f9f9f9"
			credits:
				enabled: false
			title:
				text: title
			xAxis:
				categories: cates
			yAxis:
				title:
					text: ""
					margin: 20
			tooltip:
				enabled: false

			plotOptions:
				column:
					dataLabels:
						enabled: true
						formatter: ->
							this.y + per
			legend:
				enabled: false
			series:[
				name: tip_name
				data: data
			]
		return chart_params
	setup_chart6: (data) ->
		chart_params =
			exporting:
				enabled: false
			title:
				text: "持卡等级分布"
			chart:
				plotBackgroundColor: null
				plotBorderWidth: null
				plotShadow: false
				height: 250
				backgroundColor: "#f9f9f9"
			credits:
				enabled: false
			tooltip:
				enabled: false
			plotOptions:
				pie:
					allowPointSelect: true
					cursor: 'pointer'
					dataLabels:
						enabled: true
						color: '#000000'
						connectorColor: '#000000'
						format: '<b>{point.name}</b>: {point.percentage:.1f} %'
			series:[
				type: 'pie'
				data: data
			]
		return chart_params
