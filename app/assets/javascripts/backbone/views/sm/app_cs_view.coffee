class window.SmartMerchant.AppCsView extends SmartMerchant.View
	id: "app_cs"
	template: JST['mp/app_cs']
	model: new AppVisit()
	events:
		"click .headline li a": "filter"
	render: ->
		template = @template()
		@$el.html(template)
		this
	setup_chart: (data) ->
		$(".chart",@$el).highcharts
			chart:
				zoomType: 'x'
				type: "spline"
				spacingRight: 20
				backgroundColor: "#f9f9f9"
				width: 900
			title:
				text: 'APP 数据统计'
			subtitle:
                text: '访问量&收藏量'
			xAxis:
				type: 'datetime'
				maxZoom: 30 * 24 * 360000
				title:
					text: "日期"
				labels:
					formatter: ->
						Highcharts.dateFormat("%d", this.value, false)
			yAxis:
				title: 
					text: "次数"
			tooltip:
				animation: true
				style:
					fontSize: '14px'
					padding: 8
				shared: true
				xDateFormat: "%Y年%m月%d日"
				valueSuffix: "次"
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			credits:
				enabled: false
			plotOptions:
				spline: 
					fillColor: null
					fillOpacity: 0
					marker: 
						fillColor: '#FFFFFF'
						lineWidth: 2
						lineColor: null
			series:[
				{
					name: '访问量'
					pointInterval: 24 * 3600 * 1000
					pointStart: Date.UTC(2013, 2, 1)
					fillColor:
						linearGradient:
							x1: 0
							y1: 0
							x2: 0
							y2: 1
						stops: [
							[0, Highcharts.getOptions().colors[2]]
							[1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
						]
					data: data[0]
				},
				{
					name: '收藏量'
					pointInterval: 24 * 3600 * 1000
					pointStart: Date.UTC(2013, 2, 1)
					color: Highcharts.getOptions().colors[5]
					data: data[1]
				}
			]
	extra: ->
		@model.fetch
			success: (data) =>
				@setup_chart([data.get("visit"),data.get("favorite")])
				@chart2()
		super()
	filter: (e) ->
		@app_chart = $(".chart",@$el).highcharts()
		$target = $(e.currentTarget)
		$target.parent().addClass("active").siblings().removeClass("active")
		switch $target.attr("class")
			when "yesterday"
				@app_chart.xAxis[0].setExtremes(Date.UTC(2013, 2, 29),Date.UTC(2013, 2, 30))
			when "rc7"
				@app_chart.xAxis[0].setExtremes(Date.UTC(2013, 2, 23),Date.UTC(2013, 2, 30))
			when "rc30"
				@app_chart.xAxis[0].setExtremes(Date.UTC(2013, 2, 1),Date.UTC(2013, 2, 30))
		false
	chart2: ->
		$(".chart2",@$el).highcharts
			chart:
				type: 'bar'
				backgroundColor: "#f9f9f9"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 80
				width: 900
			title:
				text: '时间分布'
			xAxis:
				categories: ['3小时内','3小时-8小时','8小时-16小时','16小时-24小时']
			yAxis: 
				min: 0
				title: 
					text: '人数百分比'
					align: 'high'
					margin: 20
				labels: 
					overflow: 'justify'
					format: "{value}%"
			credits:
				enabled: false
			tooltip:
				headerFormat: '<span style="font-size: 13px">{point.key}</span><br/>'
				valueSuffix: "%"
				style:
					fontSize: '14px'
					padding: 8
			legend: 
				enabled: false
			plotOptions: 
				bar:
					dataLabels: 
						enabled: true
						format: "{y}%"
			series: [{
				name: "时间分布"
				data: [17,57,13,18],
				color: '#8bbc21'
			}]