class window.SmartMerchantAdmin.NewAgentAccountView extends SmartMerchant.View
	id: "new_agent_account"
	template: JST['mp_admin/new_agent_account']
	model: new AgentAccounts()
	events:
		"keyup #mch_info": "word_tip"
		"change #city_select": "update_cities"
		"ajax:success #step_1": "step_1_success"
		"ajax:before #step_1": "step_1_before"
		"ajax:success #step_2": "step_2_success"
		"ajax:before #step_2": "step_2_before"
		"click .back_step_1": "back_step_1"
	initialize: ->
		super()
		@step_1_extra()
	render: ->
		@$el.html @template(@model.toJSON())
		this
	step_1_extra: ->
		$.get "/cities",(data) =>
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#city_select").append JST['mp_admin/widget/select_items'](collection: collection)
			@get_cities(collection[0][0])
		datetime_options =
			format: 'yyyy-mm-dd'
			language: "zh-CN"
			minView: 'month'
			autoclose: true
		$(".date input").datetimepicker datetime_options
	update_cities: (e) ->
		id = $(e.currentTarget).val()
		@get_cities(id)
	get_cities: (id) ->
		$.get "/cities",id: id, (data) ->
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#city_2_select").html JST['mp_admin/widget/select_items'](collection: collection)
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
	step_1_before: (e) ->
		$form = $(e.currentTarget)
		$form.find("input.required").each ->
			if $(@).val() is "" or $(@).val().length > 100
				$(@).prev().addClass 'err'
			else
				$(@).prev().removeClass 'err'
		if $form.find(".err").length > 0
			return false
		else
			obj = $form.serializeArray()
			serializedData = {}
			$.each obj, (index, field)->
				serializedData[field.name] = field.value
			@model.set serializedData
			return true
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
			if $(@).val() is "" or $(@).val().length > 25
				$(@).prev().addClass 'err'
			else
				$(@).prev().removeClass 'err'
		if $form.find(".err").length > 0
			return false
		else
			return true
	step_2_success: (e,data) ->
		if data.status is 0
			window.route.navigate("agent_manage_list",true)
		else
			alert data.msg
	back_step_1: ->
		@model.set
			step: 1
		@render()
		@step_1_extra()
	close: ->
		@model.clear(silent:true).set(@model.defaults,silent: true)
		super()