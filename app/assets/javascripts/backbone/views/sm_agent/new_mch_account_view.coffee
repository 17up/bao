class window.SmartMerchantAgent.NewMchAccountView extends SmartMerchant.View
	id: "new_mch_account"
	className: "detail"
	template: JST['mp_agent/new_mch_account']
	model: new AgentMerchants()
	events:
		"ajax:success #step_1": "step_1_success"
		"ajax:success #step_2": "step_2_success"
		"ajax:success #step_3": "step_3_success"
		"ajax:before #step_1": "step_1_before"
		"ajax:before #step_2": "step_2_before"
		"click .back_step_1": "back_step_1"
		"click .back_step_2": "back_step_2"
		"keyup #mch_info": "word_tip"
		"change #city_select": "update_cities"
		"change #catelog1_select": "update_cates"
	initialize: ->
		super()
		@step_1_extra()
	render: ->
		@$el.html @template(@model.toJSON())
		this
	close: ->
		@model.clear(silent:true).set(@model.defaults,silent: true)
		super()
	step_1_extra: ->
		$.get "/cities",(data) =>
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#city_select").append JST['mp_admin/widget/select_items'](collection: collection)
			@get_cities(collection[0][0])
		$.get "/merchant_categories/select", (data) =>
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#catelog1_select").append JST['mp_admin/widget/select_items'](collection: collection)
			@get_cate2(collection[0][0])
	get_cate2: (id) ->
		$.get "/merchant_categories/select",id: id, (data) ->
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#catelog2_select").html JST['mp_admin/widget/select_items'](collection: collection)
	update_cates: (e) ->
		id = $(e.currentTarget).val()
		@get_cate2(id)
	update_cities: (e) ->
		id = $(e.currentTarget).val()
		@get_cities(id)
	get_cities: (id) ->
		$.get "/cities",id: id, (data) ->
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#city_2_select").html JST['mp_admin/widget/select_items'](collection: collection)

	step_1_before: (e) ->
		$form = $(e.currentTarget)
		$form.find("input.required").each ->
			if $(@).val().length > 100
				alert "长度不能超过100个字符"
			if $(@).val() is "" or $(@).val().length > 100
				$(@).prev().addClass 'err'
			else
				$(@).prev().removeClass 'err'
		$ta = $(".textarea",$form)
		# if $ta.find("textarea").val() is ""
		# 	$ta.prev().addClass 'err'
		# else
		# 	$ta.prev().removeClass 'err'
		if $form.find(".err").length > 0
			return false
		else
			obj = $form.serializeArray()
			serializedData = {}
			$.each obj, (index, field)->
				serializedData[field.name] = field.value
			@model.set serializedData
			return true
	textarea_limit: ($ta,limit = 500) ->
		$tip = $ta.next()
		num = $ta.val().length
		if num > limit
			$ta.val $ta.val().substr(0, limit)
			return
		$(".num2",$tip).text num
		num
	word_tip: (e) ->
		@textarea_limit $(e.currentTarget)
	step_1_success: (e,data) ->
		if data.status is 0
			data = _.extend data.data,step: 2
			@model.set data
			@render()
		else
			alert data.msg
	step_2_before: (e) ->
		$form = $(e.currentTarget)
		$form.find("input.required").each ->
			if $(@).val() is ""
				$(@).prev().addClass 'err'
			else
				$(@).prev().removeClass 'err'
		if $form.find(".err").length > 0
			return false
		else
			return true
	back_step_1: ->
		@model.set
			step: 1
		@render()
		@step_1_extra()
	back_step_2: ->
		@model.set
			step: 2
		@render()
	step_2_success: (e,data) ->
		if data.status is 0
			@model.set step: 3
			@render()
			$.get "/packages/basic_for_select", (data) ->
				collection =  _.map data.data, (d) ->
					[d.id,d.name]
				$("#package_id").html JST['mp_admin/widget/select_items'](collection: collection)
		else
			alert data.msg
	step_3_success: (e,data) ->
		if data.status is 0
			window.route.navigate("mch_manage_list",true)
		else
			alert data.msg