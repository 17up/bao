class window.SmartMerchant.SpReportView extends SmartMerchant.View
	id: "sp_report"
	template: JST['mp/sp_report']
	model: new SpReport()
	events:
		"ajax:success a[data-remote=true]": "paginate"
		"click #return_manage": "return_manage"
	render: ->
		@model.fetch
			url: "/sp_reports/#{@mod_id}/summary"
			success: (data) =>
				template = @template(data.toJSON())			
				@$el.html(template)	
				@setup_chart(data.get("chart_data"),data.get("begin_date").split("-"))
				@render_detail()
		this
	return_manage: ->
		window.route.navigate("manage_list",true)
	render_detail: ->
		$.get "/sp_reports/#{@mod_id}/detail",(data) =>
			$("#sp_detail .sp_container").html JST['mp/item/sp_report_detail'](data.data)
	paginate: (e,data) ->
		$("#sp_detail .sp_container").html JST['mp/item/sp_report_detail'](data.data)
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