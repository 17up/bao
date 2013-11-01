# 老客户推送
class window.SmartMerchantAdmin.Push1View extends SmartMerchant.PropertyPushView
	id: "admin_push_1"
	className: "push_layout"
	template: JST['mp_admin/push_1']
	type: "returns"
	model: new Returns()
	events:
		"change #mch_name":  "mch_name_select"
		"ajax:success #step_1": "step_1_success"
		"ajax:success #step_2": "step_2_success"
		"ajax:success #step_3": "step_3_success"
		"ajax:before #step_1": "step_1_before"
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
		"keyup .reply_content": "reply_content_tip"
		"click .set_default": "set_default"
		"valueChanged .spinEdit": "spinedit"
		"change input[name='has_upset']": "toggle_sms_upset"
		"click .add_sms_upset": "add_sms_upset"
	initialize: ->
		@listenTo(@model, 'change', @render)
		$("#side_nav li a[href='#" + @id + "']").parent().addClass('active')
		if window.target_program
			program_id = window.target_program.get('program_id')
			$.get "/plan/#{window.target_program.get('attr')}/#{program_id}/edit",(data) =>
				data = _.extend data.data,program_id: program_id,has_upset: true
				@model.set data
				$("#article").html(@render().el)

				@step_2_extra(1,@model.get("count"),1)
				$("#push_content").trigger "keyup"
				if @model.get("reply_code").length > 1
					$(".upset_container .item_list").html("")
					for code,i in @model.get("reply_code")
						$(".upset_container .item_list").append JST['mp_admin/push_1/sms_upset_item'](reply_code: code,reply_content: @model.get("reply_content")[i])
				$(".reply_content").trigger "keyup"
		else
			$("#article").html(@render().el)
			@step_1_extra()
		window.route.active_view = this
	step_1_extra: ->
		$.get "/merchants",type: @type,(data) =>
			c = _.union ['',""],data.data
			mch_template = JST["mp_admin/widget/select_items"](collection: c)
			$('#mch_name',@$el).append(mch_template)
			$(".chzn-select").chosen()
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
	mch_name_select: (e) ->
		mch_id = $(e.currentTarget).val()
		$.get "/merchants/#{mch_id}",type: @type,(data) =>
			$(".selected_list",@$el).html JST['mp_admin/push_1/selected_mch'](stores: data.data)
	back_step_1: ->
		@model.set
			step: 1
		@step_1_extra()
	step_1_success: (e,data) ->
		data = _.extend data.data,step: 2
		@model.set data
		@step_2_extra(1,@model.get("count"),1)
		this
	render_rule_detail: (bdv = $("#begin_date").val(),edv = $("#end_date").val()) ->
		number = $('#number-slider').slider("value")
		begin_date = $.date(bdv, "yyyy-MM-dd").adjust("D", -1)
		end_date = $.date(edv, "yyyy-MM-dd")
		days = (end_date.date() - begin_date.date())/(3600*1000*24)
		default_num = parseInt(number/(days*1000))
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
		if a = $(".set_datetime").data("datetimepicker")
			a.remove()
		$("#hidden_rule").html JST['mp_admin/widget/time_rule'](rule_collection: data,number: number)
		$(".spinEdit").spinedit
			minimum: 0
			maximum: @model.get("count")
			step: 1

		$(".set_datetime").datetimepicker
			format: 'yyyy-mm-dd hh:ii'
			language: "zh-CN"
			autoclose: true
			minuteStep: 10
			startView: 'day'
			maxView: 'day'

	spinedit: (e) ->
		map = _.map $(".spinEdit"), (e) ->
			parseInt $(e).val()
		data = _.reduce map,(memo,num) ->
			memo + num

		if data is 0
			alert("推送人数不能为0")
			@validate_push_number = false
		else
			@validate_push_number = true
		if data > @model.get("count")
			$(e.currentTarget).spinedit("decrease")
		else
			$('#number-slider').slider( "value", data )
			$(".push_rule_title span.num").text data

		this
	reply_content_tip: (e) ->
		@textarea_limit $(e.currentTarget)
	toggle_sms_upset: (e) ->
		$(".upset_container").toggle()
		if $(e.currentTarget).attr 'checked'
			$("#reply_end").val ""
			$(".upset_container .item_list").html JST['mp_admin/push_1/sms_upset_item']()
	add_sms_upset: (e) ->
		$(".upset_container").append JST['mp_admin/push_1/sms_upset_item']()
	back_step_2: ->
		@model.set
			step: 2
		@step_2_extra(1,@model.get("count"),1)
		@render_rule_detail()
		$("#push_content").trigger "keyup"
		if @model.get("reply_code").length > 1
			$(".upset_container .item_list").html("")
			for code,i in @model.get("reply_code")
				$(".upset_container .item_list").append JST['mp_admin/push_1/sms_upset_item'](reply_code: code,reply_content: @model.get("reply_content")[i])
		$(".reply_content").trigger "keyup"
	step_1_before: (e) ->
		Utils.loading $(e.currentTarget)
		$form = $(e.currentTarget)
		if $("input[name='store_id']:checked",$form).length > 0
			true
		else
			alert("请先选择一家门店")
			Utils.loaded $(e.currentTarget)
			false
	step_2_before: (e) ->
		vt = @validate_title(e)
		vd = @validate_date()
		vc = @validate_content(e)
		vu = !$("input[name='has_upset']").attr('checked') || @validate_upset_content()
		vt and vc and vd and @validate_push_number and vu
	move_top: ->
		unless @validate_date() is false
			val = $('#number-slider').slider("value")
			$('#number-slider').slider( "value", val + 5 )
			@model.unset "push_number_perday",silent: true
			@render_rule_detail()
		this
	move_down: ->
		unless @validate_date() is false
			val = $('#number-slider').slider("value")
			$('#number-slider').slider( "value", val - 5 )
			@model.unset "push_number_perday",silent: true
			@render_rule_detail()
		this
	# 验证下行文案
	validate_upset_content: ->
		valid = true
		for ele in $("textarea[name='reply_content[]']")
			content = $.trim $(ele).val()
			if content is ''
				$("#sms_upset .err_tip").text "请确保短信上行内容及下行文案填写完整"
				valid = false
				return false
		return valid