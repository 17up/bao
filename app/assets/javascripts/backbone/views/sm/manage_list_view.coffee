class window.SmartMerchant.ManageListView extends SmartMerchant.View
	id: "manage_list"
	template: JST['mp/manage_list']
	collection: new SmartMerchant.Programs()
	events:
		"click .add_custom": "add_custom"
		"click .add_property": "add_property"
		"click #check_sp_result": "check_sp_result"
		"click .back": "back"
	render: ->
		template = @template()
		@$el.html(template)	
		this
	extra: ->
		@collection.fetch
			success: (data) =>
				property_group = data.where p_type: 2
				custom_group = data.where p_type: 3
				for d in property_group
					@add_property_item(d)	
				for d in custom_group
					@add_custom_item(d)
		super()
	back: ->
		@render()
		@extra()
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


		
