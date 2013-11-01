class window.SmartMerchantAgent.MchDetailView extends SmartMerchant.View
	id: "mch_detail"
	className: "detail"
	template: JST['mp_agent/mch_detail']
	events:
		"click .back": "back"
		"click .modify_pw": "modify_pw"
		"click .edit": "edit"
		"ajax:success #change_pw_form": "pw_success"
		"ajax:before #change_pw_form": "pw_before"
		"ajax:before #mch_info_form": "before_edit"
		"ajax:success #mch_info_form": "success_edit"
		"click .cancel": "back_detail"
		"change #city_select": "update_cities"
		"change #catelog1_select": "update_cates"
		"keyup #mch_info": "word_tip"
	render: ->
		$.get "/merchants/#{@mch_id}/detail",(data) =>
			mdata = _.extend data.data.info,mid_attachment: data.data.mid_attachment
			@model = new AgentMerchant(mdata)
			@$el.html @template(info: @model.toJSON(),package: data.data.package)
		this
	back: ->
		window.route.navigate("mch_manage_list",true)
	modify_pw: ->
		@$el.html JST['mp_agent/mch_detail/change_password'](@model.toJSON())
		this
	edit: ->
		d = _.extend @model.toJSON(),edit: true
		@$el.html JST["mp_agent/mch_detail/edit"](d)
		$.get "/cities",(data) =>
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#city_select").append JST['mp_admin/widget/select_items'](collection: collection)
			$("#city_select").val @model.get('parent_city_id')
			@get_cities @model.get('parent_city_id'), =>
				$("#city_2_select").val @model.get("city_id")
		$.get "/merchant_categories/select", (data) =>
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#catelog1_select").append JST['mp_admin/widget/select_items'](collection: collection)
			$("#catelog1_select").val @model.get("parent_category_id")
			@get_cate2 @model.get("parent_category_id"), =>
				$("#catelog2_select").val @model.get("category_id")

		$("#mch_info").trigger "keyup"
		this
	get_cate2: (id,onSuccess) ->
		$.get "/merchant_categories/select",id: id, (data) ->
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#catelog2_select").html JST['mp_admin/widget/select_items'](collection: collection)
			onSuccess() if onSuccess
	update_cates: (e) ->
		id = $(e.currentTarget).val()
		@get_cate2(id)
	update_cities: (e) ->
		id = $(e.currentTarget).val()
		@get_cities(id)
	get_cities: (id,onSuccess) ->
		$.get "/cities",id: id, (data) ->
			collection =  _.map data.data, (d) ->
				[d.id,d.name]
			$("#city_2_select").html JST['mp_admin/widget/select_items'](collection: collection)
			onSuccess() if onSuccess
	pw_success: (e,data) ->
		if data.status is 0
			@back_detail()
		else
			alert data.msg
	pw_before: ->
		$input = $("input.required")
		if $input.val() is "" or $input.val().length > 25
			$input.focus().prev().addClass 'err'
			return false
		else
			$input.prev().removeClass 'err'
	back_detail: (e) ->
		@render()
	before_edit: (e) ->
		$form = $(e.currentTarget)
		$form.find("input.required").each ->
			if $(@).val() is ""
				$(@).prev().addClass 'err'
			else
				$(@).prev().removeClass 'err'
		$ta = $(".textarea",$form)
		if $form.find(".err").length > 0
			return false
	success_edit: (e,data) ->
		if data.status is 0
			@render()
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