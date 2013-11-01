class window.SmartMerchant.PropertyPushView extends SmartMerchant.PushProgramView
	id: "property_push"
	className: "push_layout"
	template: JST['mp/property_push']
	model: new Property()
	per_number: 1
	events:
		"ajax:success #step_1": "step_1_success"
		"ajax:success #step_2": "step_2_success"
		"ajax:success #step_3": "step_3_success"
		"ajax:before #step_2": "step_2_before"
		"ajax:before #step_3": "step_3_before"
		"click .back_step_1": "back_step_1"
		"click .back_step_2": "back_step_2"
		"click .m-top": "move_top"
		"click .m-down": "move_down"
		"changeDate input[name='begin_date']": "change_begin_date"
		"changeDate input[name='end_date']": "change_end_date"
		"click .set_rule": "set_rule"
		"keyup #push_content": "word_tip"
		"click .set_default": "set_default"
		"valueChanged .spinEdit": "spinedit"
	initialize: ->
		@listenTo(@model, 'change', @render)
		$("#side_nav li a[href='#" + @id + "']").parent().addClass('active')
		if window.target_program
			$.get "/plan/personals/options?id=#{window.target_program.get('program_id')}",(data) =>
				@model.set data.data
				$("#article").html(@render().el)
				@step_2_extra()
				$("#push_content").trigger "keyup"
		else
			@model.fetch
				success: (data) =>
					$("#article").html(@render().el)
		window.route.active_view = this
	close: ->
		new_data = _.extend @model.defaults,step: 1
		@model.clear(silent:true).set(new_data,silent: true)
		window.target_program = null
		super()
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	step_2_extra: (min = 1000,max = 1000000,step = 1000) ->
		@setup_date_picker()
		if $(".slider input").val() == ''
			number_value = min
		else
			number_value = $(".slider input").val()
			$(".slider .num").text number_value + "条"
		$('#number-slider').slider
			min: min
			max: max
			step: step
			value: number_value
			range: "min"
			slide: (event,ui) ->
				left = $(ui.handle).css 'left'
				$(".slider .num").text ui.value + "条"
				$(".slider input").val ui.value
				$(".slider .num").css "left":left
			start: (e) =>
				$(".slider .num_wrap").show()
				@model.unset "push_number_perday",silent: true
			stop: (e) =>
				$(".slider .num_wrap").hide()
				unless @validate_date() is false
					@render_rule_detail()
			change: (e,ui) =>
				@change_summary ui.value
	back_step_1: ->
		@model.set
			step: 1
	back_step_2: ->
		@model.set
			step: 2
		@step_2_extra()
		@render_rule_detail()
		$("#push_content").trigger "keyup"
	step_2_before: (e) ->
		vt = @validate_title(e)
		vd = @validate_date()
		vc = @validate_content(e)
		vm = @validate_money(e)
		vt and vc and vd and vm
	step_3_before: (e) ->
		Utils.loading $(e.currentTarget)
	step_1_success: (e,data) ->
		data = _.extend data.data,step: 2
		@model.set data
		@step_2_extra()
		Utils.loaded $(e.currentTarget)
		this
	step_2_success: (e,data) ->
		if data.status is 0
			data = _.extend data.data,step: 3,token: window.token
			@model.set data
		else
			alert data.msg
		this
	step_3_success: (e,data) ->
		Utils.loaded $(e.currentTarget)
		window.route.navigate("manage_list",true)
		this
	move_top: ->
		unless @validate_date() is false
			val = $('#number-slider').slider("value")
			$('#number-slider').slider( "value", val + 1000 )
			@render_rule_detail()
		this
	move_down: ->
		unless @validate_date() is false
			val = $('#number-slider').slider("value")
			$('#number-slider').slider( "value", val - 1000 )
			@render_rule_detail()
		this
	change_begin_date: (e) ->
		super(e)
		unless $("#end_date").val() is ''
			@render_rule_detail()
	change_end_date: (e) ->
		super(e)
		unless $("#begin_date").val() is ''
			@render_rule_detail()
	render_rule_detail: (bdv = $("#begin_date").val(),edv = $("#end_date").val()) ->
		number = $('#number-slider').slider("value")
		begin_date = $.date(bdv, "yyyy-MM-dd").adjust("D", -1)
		end_date = $.date(edv, "yyyy-MM-dd")
		days = (end_date.date() - begin_date.date())/(3600*1000*24)
		default_num = Number(number/(days*1000))
		default_mod = number%(days*1000)

		data = _.map [1..days],(i) =>
			f = begin_date.adjust("D", +1)
			if @model.get("push_number_perday")
				dn = @model.get("push_number_perday")[i-1]
			else
				dn = if i is days then default_num*1000 + default_mod else default_num*1000
			"date": f.format("yyyy-MM-dd")
			"weekday": f.format("dddd")
			"default": dn

		$("#hidden_rule").html JST['mp/widget/time_rule'](rule_collection: data,number: number)
		$(".spinEdit").spinedit
			minimum: 0
			maximum: 1000000
			step: 1000
	spinedit: (e) ->
		map = _.map $(".spinEdit"), (e) ->
			Number $(e).val()
		data = _.reduce map,(memo,num) ->
			memo + num
		if data < 1000
			$(e.currentTarget).spinedit('increase')
		else if data > 1000000
			$(e.currentTarget).spinedit("decrease")
		else
			$('#number-slider').slider( "value", data )
			$(".push_rule_title span.num").text data
		this
	set_rule: ->
		unless @validate_date() is false
			$("#hidden_rule").toggle()
			if $("#hidden_rule").html() is ''
				@render_rule_detail()
		this
	set_default: ->
		@render_rule_detail()
	change_summary: (val) ->
		all_number = val*@per_number
		$(".push_number .big_num").text all_number
		buy_number = all_number - @model.get("personal")
		buy_number = if buy_number < 0 then 0 else buy_number
		$(".buy_number .big_num").text("#{buy_number}条")

	word_tip: (e) ->
		super(e)
		@change_summary $('#number-slider').slider("value")
	validate_money: (e) ->
		$action = $(e.currentTarget).find(".action")
		has_num = Number @model.get("personal")
		need_num = $('#number-slider').slider("value")*@per_number - has_num
		if need_num > 0
			$(".err_tip",$action).text "您的个性化短信剩余#{has_num}条，还需购买#{need_num}条！"
			false
