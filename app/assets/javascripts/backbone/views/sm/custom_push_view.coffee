class window.SmartMerchant.CustomPushView extends SmartMerchant.PushProgramView
	id: "custom_push"
	className: "push_layout"
	template: JST['mp/custom_push']
	model: new Custom()
	per_number: 1
	events:
		"click .add_list": "add_list"
		"click .select_list": "select_list"
		"keyup #push_content": "word_tip"
		"changeDate input[name='begin_date']": "change_begin_date"
		"ajax:before #custom_form": "custom_form_before"
		"ajax:success #custom_form": "custom_form_success"
		"keyup #push_mobiles": "push_mobiles_tip"
		"ajax:success #new_namelist": "new_namelist_success"
		"ajax:success #select_namelist": "select_namelist_success"
		"ajax:before #new_namelist": "new_namelist_before"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	close: ->
		@model.clear()
		window.target_program = null
		super()
	extra: ->
		$.get "/merchants/available_sms_count", (data) =>
			@model.set custom: parseInt(data.data.custome)
		if window.target_program
			$.get "/plan/customs/#{window.target_program.get('program_id')}/mobiles", (data) =>
				d = _.extend data.data,mobiles: data.data.mobiles.join("\n")
				@model.set d
				@render()
				$("#push_mobiles").trigger "keyup"
				$("#push_content").trigger "keyup"
		@setup_date_picker()
		super()
	add_list: ->
		$modal = $("#add_list_modal")
		if @validate_mobiles()
			$modal.modal()
		this
	select_list: ->
		$.get "/name_lists",(data) =>
			if data.status is 0
				$("#select_list_modal").html JST['mp/widget/select_list_modal'](data.data)
				$modal = $("#select_list_modal")
				$modal.modal()
		this
	paginate: (e,data) ->
		$("#select_list_modal").html JST['mp/widget/select_list_modal'](data.data)
	new_namelist_success: (e,data) ->
		$modal = $("#add_list_modal")
		$modal.find("form")[0].reset()
		$modal.modal("hide")
		Utils.loaded $(e.currentTarget).find("input[type='submit']")
	new_namelist_before: (e) ->
		$input = $(e.currentTarget).find("input[name='name']")
		if $input.val() is ''
			$input.focus()
			$(e.currentTarget).find(".err_tip").text "请为新名单命名"
			false
		else
			Utils.loading $(e.currentTarget).find("input[type='submit']")
	select_namelist_success: (e,data) ->
		if data.status is 0
			$("#push_mobiles").val data.data.join("\n")
			$modal = $("#select_list_modal")
			$modal.modal("hide")
			$("#push_mobiles").trigger "keyup"
	custom_form_before: (e) ->
		vt = @validate_title(e)
		vd = @validate_date()
		vc = @validate_content(e)
		vm = @validate_mobiles()
		vmo = @validate_money(e)
		if vt and vm and vd and vc and vmo
			Utils.loading $(e.currentTarget).find("input[type='submit']")
		else
			false
	custom_form_success: (e,data) ->
		if data.status is 0
			window.route.navigate("manage_list",true)
		else
			alert data.msg
		this
	validate_mobiles: ->
		$textarea = $("#push_mobiles")
		$tip = $(".push_mobiles").find(".err_tip")
		mobiles = $textarea.val().match(/\d+/g)

		if mobiles
			for m in mobiles
				if m.length isnt 11
					$tip.text "您输入正确格式的手机号码"
					return false
			$tip.text ""
			$("input[name='mobiles']").val mobiles.join(",")
		else
			$tip.text "您输入正确格式的手机号码"
			return false
	push_mobiles_tip: (e) ->
		$target = $(e.currentTarget)
		if reg = $target.val().match(/\d+/g)
			@mobile_num = reg.length
			$(".push_mobiles .num4").text @mobile_num
	validate_money: (e) ->
		$action = $(e.currentTarget).find(".action")
		has_num = @model.get("custom")
		need_num = @mobile_num*@per_number - has_num
		#console.log need_num
		if need_num > 0
			$(".err_tip",$action).text "您的自定义短信剩余#{has_num}条，还需购买#{need_num}条！"
			false
		else
			true
