class window.SmartMerchant.MonthAnalyticsView extends SmartMerchant.View
	id: "month_analytics"
	template: JST['mp/month_analytics']
	events:
		"click a[href='#tab-2']": "tab2"
	render: ->
		template = @template()
		@$el.html(template)
		this
	extra: ->
		@setup_chart([3,44,2,44,3],['2013','9','24'])
		@setup_chart2([100,200,160,190,230,400,40,80],$("#chart2",@$el))
		# @setup_chart4([100,200,160,190,230,400,40,80],$("#chart4",@$el))
		# @setup_chart4([100,200,160,190,230,400,40,80],$("#chart5",@$el))
		# @setup_chart6([['weibo',12],['weixin',45],['qq',20]],$("#chart6",@$el))
		datetime_options = 
			format: 'yyyy-mm-dd'
			language: "zh-CN"
			minView: 'month'
			startDate: $.date().adjust("D", -30).date()
			endDate: $.date().adjust("D", -1).date()
		$(".date input").datetimepicker datetime_options
		super()
	tab2: ->
		chart = $("#chart2",@$el).highcharts()
		chart.setSize($("#article").width())
	setup_chart: (data,begin_date) ->
		$("#chart1",@$el).highcharts
			exporting:
				enabled: false
			chart:
				type: "spline"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 80
				height: 400
				backgroundColor: "#f9f9f9"
			credits:
				enabled: false
			title:
				text: ""
			xAxis:
				type: 'datetime'
				tickInterval: 24 * 3600 * 1000
				# title:
				# 	text: "xx"
				# 	margin: 20
				labels:
					formatter: ->
						Highcharts.dateFormat("%m/%d", this.value, false)
			yAxis:
				title:
					text: "发送量"
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
				valueSuffix: "条"
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			legend: 
				enabled: false
			series:[
				name: '推送'
				pointInterval: 24 * 3600 * 1000
				pointStart: Date.UTC(parseInt(begin_date[0]), parseInt(begin_date[1]) - 1, parseInt(begin_date[2]))
				data: data
			]
	setup_chart2: (data,$ele) ->
		$ele.highcharts
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
				#width: 900
			credits:
				enabled: false
			title:
				text: ""
			xAxis:
				categories: ["2-2.5","7.5-8.8","13-15","20-22","31-35","58-65","200-400","400-1000"]
			yAxis:
				title:
					text: "笔数"
					margin: 20
#			plotOptions: 
#				column: 

			tooltip:
				animation: true
				style:
					fontSize: '14px'
					padding: 8
				shared: true
				valueSuffix: "笔"
				headerFormat: '<span style="font-size: 14px">客单价{point.key}</span><br/>'
			legend: 
				enabled: false
			series:[
				name: '笔数'
				data: data
			]
	setup_chart4: (data,$ele) ->
		$ele.highcharts
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
				width: 400
			credits:
				enabled: false
			title:
				text: ""
			xAxis:
				categories: ["2-2.5","7.5-8.8","13-15","20-22","31-35","58-65","200-400","400-1000"]
			yAxis:
				title:
					text: "笔数"
					margin: 20
#			plotOptions: 
#				column: 

			tooltip:
				animation: true
				style:
					fontSize: '14px'
					padding: 8
				shared: true
				valueSuffix: "笔"
				headerFormat: '<span style="font-size: 14px">客单价{point.key}</span><br/>'
			legend: 
				enabled: false
			series:[
				name: '笔数'
				data: data
			]
	setup_chart6: (data,$ele) ->
		$ele.highcharts
			exporting:
				enabled: false
			title:
				text: ""
			chart:
				plotBackgroundColor: null
				plotBorderWidth: null
				plotShadow: false
				height: 250
				width: 400
				backgroundColor: "#f9f9f9"
			credits:
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
				name: '笔数'
				data: data
			]