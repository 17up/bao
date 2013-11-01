class window.SmartMerchant.HomepageView extends SmartMerchant.View
	id: "homepage"
	template: JST['mp/home_page']
	model: new MonthAnaly()
	render: ->
		@$el.html @template()
		@model.fetch
			url: "/operates/latestoverview"
			success: (data) =>
				json = data.toJSON()
				begin_month = json.begin_date.split("-")[1]
				$("#summary_header").html "#{begin_month}月份月度经营分析报告"
				@render_summary(json)
		this

	render_summary: (json) ->
		$("#r1_summary").html JST['mp/month_analytics/summary'](json)
		@render_charts(json.daily,json.begin_date.split("-"))
	render_charts: (data,bg_date) ->
		$("#chart1",@$el).highcharts @setup_chart(data.tick_count,bg_date,"笔数","成交笔数","笔")
		$("#chart2",@$el).highcharts @setup_chart(data.tick_people,bg_date,"人数","成交人数","人")
		$("#chart3",@$el).highcharts @setup_chart(data.tick_amount,bg_date,"金额","成交金额","元")
		$("#chart4",@$el).highcharts @setup_chart(data.tick_per,bg_date,"客单价","客单价","元")
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
				offset: 10
				# title:
				# 	text: "xx"
				# 	margin: 20
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
