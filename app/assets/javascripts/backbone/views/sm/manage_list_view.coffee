class window.SmartMerchant.ManageListView extends SmartMerchant.View
	id: "manage_list"
	template: JST['mp/manage_list']
	collection1: new SmartMerchant.Programs()
	collection2: new SmartMerchant.Programs()
	collection3: new SmartMerchant.Programs()
	events:
		"click .add_custom": "add_custom"
		"click .add_property": "add_property"
		"click #check_sp_result": "check_sp_result"
		"click .back": "back"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		template = @template()
		@$el.html(template)
		this
	extra: ->
		@collection3.fetch
			url: "/plan/plans"
			success: (data) =>
				$("#personal_list").html JST['mp/manage_list/property_list'](pagination_str: @collection3.pagination_str)
				for d in data.models
					@add_personal_item(d)
		@collection1.fetch
			url: "/plan/customs"
			success: (data) =>
				$("#custom_list").html JST['mp/manage_list/custom_list'](pagination_str: @collection1.pagination_str)
				for d in data.models
					@add_custom_item(d)
		@collection2.fetch
			url: "/plan/personals"
			success: (data) =>
				$("#property_list").html JST['mp/manage_list/property_list'](pagination_str: @collection2.pagination_str)
				for d in data.models
					@add_property_item(d)
		super()
	paginate: (e,data) ->
		$con = $(e.currentTarget).closest(".main-container")
		switch $con.attr("id")
			when "custom_list"
				$("#custom_list").html JST['mp/manage_list/custom_list'](pagination_str: data.data.pagination_str)
				collection = new SmartMerchant.Programs(data.data.programs)
				for d in collection.models
					@add_custom_item(d)
			when "personal_list"
				$("#personal_list").html JST['mp/manage_list/property_list'](pagination_str: data.data.pagination_str)
				collection = new SmartMerchant.Programs(data.data.programs)
				for d in collection.models
					@add_personal_item(d)
			when "property_list"
				$("#property_list").html JST['mp/manage_list/property_list'](pagination_str: data.data.pagination_str)
				collection = new SmartMerchant.Programs(data.data.programs)
				for d in collection.models
					@add_property_item(d)
		this
	back: ->
		@render()
		@extra()
	add_personal_item: (model) ->
		model.set uneditable: true
		view = new SmartMerchant.SpReportItemView
			model: model
		$("#personal_list table",@$el).append(view.render().el)
	add_property_item: (model) ->
		view = new SmartMerchant.SpReportItemView
			model: model
		$("#property_list table",@$el).append(view.render().el)
	add_custom_item: (model) ->
		view = new SmartMerchant.SpReportItemView
			model: model
		$("#custom_list table",@$el).append(view.render().el)
	add_property: (e) ->
		window.route.navigate("property_push",true)
		this
	add_custom: (e) ->
		window.route.navigate("custom_push",true)
		this
	check_sp_result: (e) ->
		window.route.navigate("sp_result",true)
		this



