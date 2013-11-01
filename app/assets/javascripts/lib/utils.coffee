class window.Utils
	@flash: (msg,type='',$container) ->
		$container = $container || $("#article")
		$container.prepend JST['widget/flash'](msg:msg)
		$alert = $(".alert:first-child",$container)
		if type isnt ''
			$alert.addClass "alert-#{type} flash"
		$alert.slideDown()
		fuc = ->
			$alert.slideUp ->
				$(@).remove()
		setTimeout fuc,5000
		false
	@loading: ($item) ->
		$item.addClass 'disable_event'
		$item.queue (next) ->
			$(@).animate({opacity: 0.2},800).animate({opacity: 1},800)
			$(@).queue(arguments.callee)
			next()
	@loaded: ($item) ->
		$item.stop(true).css "opacity",1
		$item.removeClass 'disable_event'
	@loading2: ($item) ->
		$item.append JST['widget/loading']()
		$(".loading2",$item)
	@chart1: ($chart,d1,d2,d3) ->
		number = Number(d1) + Number(d2) + Number(d3)
		$chart.highcharts
			chart:
				type: 'bar'
				height: 300
				backgroundColor: "#f0f0f0"
				spacingRight: 220
			exporting:
				enabled: false
			title:
				text: '推送方式'
			subtitle:
				y: 40
				text: "系统依据您与本行业的整体交易概况,为您精心挑选了" + number + "位潜在客户,并为您确定了最优化的推送方式。"
			xAxis:
				categories: ['推送方式']
				labels:
					enabled: false
			yAxis:
				title:
					enabled: false
			credits:
				enabled: false
			tooltip:
				enabled: false
				# headerFormat: '<span style="font-size: 13px">{series.name}</span><br/>'
				# positioner: ->
				# 	x: 15
				# 	y: -10
			legend:
				enabled: false
			plotOptions:
				bar:
					pointPadding: 0.3
					dataLabels:
						enabled: true
						style:
							fontSize: "14px"
			series: [{
				name: '目标新客户'
				dataLabels:
					color: '#0bf'
					formatter: ->
						"主动推送目标新客户: " + this.y
				# events:
				# 	mouseOver: ->
				# 		$(".preview-panel").show().css
				# 			"top": "35px"
				# 			"left": "0px"
				# 		$(".preview-panel .content").html(this.name + "<br/>按照预定发送时间与数量主动推送短信")
				# 	mouseOut: ->
				# 		$(".preview-panel").hide()
				data: [d3]
				color: '#0bf'

			},{
				name: '回头客'
				dataLabels:
					color: '#8bbc21'
					formatter: ->
						"主动推送回头客: " + this.y
				# events:
				# 	mouseOver: ->
				# 		$(".preview-panel").show().css
				# 			"top": "35px"
				# 			"left": "0px"
				# 		$(".preview-panel .content").html(this.name + "<br/>按照预定发送时间与数量主动推送短信")
				# 	mouseOut: ->
				# 		$(".preview-panel").hide()
				data: [d2]
				color: '#8bbc21'
			}, {
				name: '刷卡触发'
				# events:
				# 	mouseOver: ->
				# 		$(".preview-panel").show().css
				# 			"top": "-15px"
				# 			"left": "0px"
				# 		$(".preview-panel .content").html(this.name + "<br/>在您所在商圈其他商户刷卡消费，即触发推送短信")
				# 	mouseOut: ->
				# 		$(".preview-panel").hide()
				dataLabels:
					color: '#4897f1'
					formatter: ->
						"刷卡触发: " + this.y
				data: [d1]
			}]