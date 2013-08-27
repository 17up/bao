class window.SmartMerchant.CustomPushView extends SmartMerchant.PushProgramView
	id: "custom_push"
	template: JST['mp/custom_push']
	model: new Custom()
	events:
		"click .add_list": "add_list"
		"click .select_list": "select_list"
		"keyup #push_content": "word_tip"
		"changeDate input[name='begin_date']": "change_begin_date"
		"changeDate input[name='end_date']": "change_end_date"
		"ajax:before #custom_form": "custom_form_before"
		"ajax:success #custom_form": "custom_form_success"
		"keyup #push_mobiles": "push_mobiles_tip"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	close: ->
		@model.clear()
		super()
	extra: ->
		@setup_date_picker()
		super()
	add_list: ->
		$modal = $("#add_list_modal")
		$modal.modal()
		this
	select_list: ->
		$modal = $("#select_list_modal")
		$modal.modal()
		this
	custom_form_before: (e) ->
		vt = @validate_title(e) 
		vd = @validate_date() 
		vc = @validate_content(e)
		vt and vc and vd
	custom_form_success: (e) ->
		window.route.navigate("manage_list",true)
		this
	push_mobiles_tip: (e) ->
		$target = $(e.currentTarget)
		if reg = $target.val().match(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g)
			num = reg.length
			$(".push_mobiles .num4").text num