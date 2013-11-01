class window.SmartMerchant.ShopCsView extends SmartMerchant.View
	id: "shop_cs"
	template: JST['mp/shop_cs']
	model: new Consume()
	events:
		"change #filter": "filter"
	render: ->
		@model.fetch
			success: (data) =>
				template = @template(store_name: data.get("store_name"))
				@$el.html(template)
				date_start = data.get("date")[0]
				@model.set
					rc7: data.get("rc7")
					rc30: data.get("sum")
				@setup_chart(data.get("consume"),date_start.split("-"),data.get("sum"))
				@chart2(data.get("price_cnt"))
				$(".copyright").hide()
				$(window).resize()
		this
	setup_chart: (data,date,all_consume) ->
		$(".chart",@$el).highcharts
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
				text: "刷卡交易总金额：" + all_consume + "元"
			xAxis:
				type: 'datetime'
				tickInterval: 24 * 3600 * 1000
				title:
					text: "消费日期"
					margin: 20
				labels:
					formatter: ->
						Highcharts.dateFormat("%m-%d", this.value, false)
			yAxis:
				title:
					text: "消费金额（元）"
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
				xDateFormat: "%Y年%m月%d日"
				valueSuffix: "元"
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			legend:
				enabled: false
			series:[
				name: '消费'
				pointInterval: 24 * 3600 * 1000
				pointStart: Date.UTC(Number(date[0]), Number(date[1]) - 1, Number(date[2]))
				data: data
			]
		today = $.date().adjust("D", -1).date()
		ty = today.getFullYear()
		tm = today.getMonth()
		td = today.getDate()
		r7 = $.date().adjust("D", -7).date()
		y = r7.getFullYear()
		m = r7.getMonth()
		d = r7.getDate()
		$chart = $(".chart",@$el).highcharts()
		$chart.xAxis[0].setExtremes(Date.UTC(y,m,d),Date.UTC(ty,tm,td))
		$chart.setTitle
			text: "刷卡交易总金额：" + @model.get("rc7") + "元"
	filter: (e) ->
		@consume_chart = $(".chart",@$el).highcharts()
		$target = $(e.currentTarget)
		$target.parent().addClass("active").siblings().removeClass("active")
		today = $.date().adjust("D", -1).date()
		ty = today.getFullYear()
		tm = today.getMonth()
		td = today.getDate()
		switch $target.val()
			when "yesterday"
				yesterday = $.date().adjust("D", -1).date()
				y = yesterday.getFullYear()
				m = yesterday.getMonth()
				d = yesterday.getDate()
				@consume_chart.xAxis[0].setExtremes(Date.UTC(y,m,d),Date.UTC(ty,tm,td))
			when "rc7"
				r7 = $.date().adjust("D", -7).date()
				y = r7.getFullYear()
				m = r7.getMonth()
				d = r7.getDate()
				@consume_chart.xAxis[0].setExtremes(Date.UTC(y,m,d),Date.UTC(ty,tm,td))
				@consume_chart.setTitle
					text: "刷卡交易总金额：" + @model.get("rc7") + "元"
			when "rc30"
				r30 = $.date().adjust("D", -30).date()
				y = r30.getFullYear()
				m = r30.getMonth()
				d = r30.getDate()
				@consume_chart.xAxis[0].setExtremes(Date.UTC(y,m,d),Date.UTC(ty,tm,td))
				@consume_chart.setTitle
					text: "刷卡交易总金额：" + @model.get("rc30") + "元"
		false
	chart2: (data) ->
		$(".chart2",@el).highcharts
			chart:
				type: 'bar'
				backgroundColor: "#f9f9f9"
				spacingRight: 25
				spacingTop: 25
				spacingLeft: 25
				spacingBottom: 80
				height: 400
			credits:
      			enabled: false
			title:
				text: '本商户客单价金额分布'
			xAxis:
				categories: ['0-100元','101-500元','501-1000元','1001-2000元','2000元以上']
			yAxis:
				min: 0
				title:
					text: '金额百分比'
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
				name: "金额分布"
				data: data,
				color: '#8bbc21'
			}]
	chart3: ->
		$(".chart2",@$el).highcharts
			chart:
				plotBackgroundColor: null
				plotBorderWidth: null
				plotShadow: false
			title:
				text: '交易分布'
			tooltip:
				style:
					fontSize: '14px'
					padding: 8
				pointFormat: '{series.name}: <b>{point.percentage}%</b>'
				percentageDecimals: 1
				headerFormat: '<span style="font-size: 14px">{point.key}</span><br/>'
			plotOptions:
				pie:
					animation: true
					allowPointSelect: true
					cursor: 'pointer'
					dataLabels:
						enabled: true
						color: '#000000'
						connectorColor: '#000000'
						formatter: ->
							'<b>' + this.point.name + '</b>: ' + this.percentage + ' %'
			series: [{
				type: 'pie',
				name: '消费占比',
				data: [
					['上海',   45.0],
					['广州',       26.8],
					{
						name: '杭州',
						y: 12.8,
						sliced: true,
						selected: true
					},
					['深圳',    8.5],
					['北京',     6.2],
					['其他',   0.7]
				]
			}]
