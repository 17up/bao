class window.SmartMerchant.NewPushView extends SmartMerchant.View
	id: "new_push"
	template: JST['mp/new_push']
	model: new Plan()
	events:
		"click .preview": "preview"
		"click .submit": "submit"
		"click .back": "back"
		"keyup #push_content": "word_tip"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		if @model.get("preview")
			Utils.chart1($(".chart1",@$el),@model.get("trigger_num"),@model.get("active_rt_num"),@model.get("active_nw_num"))
		this
	back: ->
		@model.set 
			preview: false
			modify: true
		@render()
		@textarea_limit $("#push_content")
		@extra()
		this
	submit: ->
		name = @model.get("plan_name") + "_" + (new Date()).getTime()
		@model.save {plan_name: name},success: (m,resp) ->
			if resp.status is 0											
				if window.reports
					window.reports = null
				m.clear()
				window.route.navigate("plan",true)
				Utils.flash("方案新建成功","success",$(".main"))
		this
	textarea_limit: ($ta,limit = 128) ->		
		$tip = $ta.next()
		num = $ta.val().length
		if num > limit
			$ta.val $ta.val().substr(0, limit)
			return
		wcnt = limit - num
		$(".num1",$tip).text num
		$(".num3",$tip).text wcnt
		if num > 0
			if num <= 64
				num2 = 1
			else if num <= limit
				num2 = 2
		else
			num2 = 0
		$(".num2",$tip).text num2
		
	word_tip: (e) ->
		@textarea_limit $(e.currentTarget)
	close: ->
		super()
		@model.clear()
	extra: ->
		$(".date").datetimepicker
			format: 'yyyy-mm-dd'
			language: "zh-CN"
			minView: 'month'
		$("input").blur ->
			if $(@).val() isnt ''
				$(".er-tip").hide()
		if $(".slider input").val() == ''
			number_value = 1000
		else
			number_value = $(".slider input").val()
			$(".slider .num").text "您设置的发送数量为" + number_value + "条"
		$('#number-slider').slider
			min: 1000
			max: 100000
			step: 1000
			value: number_value
			range: "min"
			slide: (event,ui) ->
				$(".slider .num").text "您设置的发送数量为" + ui.value + "条"
				$(".slider input").val ui.value
		super()
	preview: (e) ->
		name = $.trim $("#push_name",@$el).val()
		content = $.trim $("#push_content",@$el).val()
		active_begin = $("#push_date_start").val()
		active_end = $("#push_date_end").val()
		number = $("#number").val()
		if name is ''
			$("#push_name",@$el).focus()
			$gp = $("#push_name",@$el).closest(".control-group").find(".er-tip").show()
			return
		if active_begin is ''
			$("#push_date_start").focus()
			return
		if active_end is ''
			$("#push_date_end").focus()
			return
		if $.date(active_begin,"yyyy-MM-dd").date() >= $.date(active_end,"yyyy-MM-dd").date()
			$("#push_date_start").closest(".control-group").find(".er-tip1").show()
			return
		else if $.date(active_begin,"yyyy-MM-dd").date() < $.date().adjust("D", 3).date()
			$("#push_date_start").closest(".control-group").find(".er-tip2").show()
			return
		else if $.date(active_end,"yyyy-MM-dd").date() > $.date(active_begin,"yyyy-MM-dd").adjust("D", 7).date()
			$("#push_date_start").closest(".control-group").find(".er-tip3").show()
			return
		if content is ''
			$("#push_content",@$el).focus()	
			$("#push_content",@$el).blur ->
				if $(@).val() isnt ''
					$(".error-tip").hide()
			$("#push_content",@$el).closest(".control-group").find(".error-tip").show()
			return

		$.post "/mp/preview_plan",
			active_begin: active_begin
			active_end: active_end
			number: number
			(data) =>
				if data.status is 0
					@model.set
						plan_name: name 
						content: content
						active_begin: active_begin
						active_end: active_end
						number: number
						active_rt_num: data.data.retu
						active_nw_num: data.data.newu
						trigger_num: data.data.trigger
						active_num: data.data.active
						store_id: 6
						preview: true
					@render()
	