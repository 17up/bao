class window.SmartMerchantAdmin.ManageListView extends SmartMerchant.View
	id: "manage_list"
	template: JST['mp_admin/manage_list']
	collection: new SmartMerchant.Programs()
	events:
		"ajax:success a[data-remote=true]": "paginate"
		"click .back": "back"
	render: ->
		# console.log window.current_page
		page = window.current_page || 1
		@collection.fetch
			url: "/plan/plans?page=#{page}"
			success: (data) =>
				@$el.html @template(pagination_str: data.pagination_str)
				for d in data.models
					@add_item(d)
		this
	back: ->
		@render()
	paginate: (e,data) ->
		@$el.html @template(data.data)
		collection = new SmartMerchant.Programs(data.data.programs)
		for d in collection.models
			@add_item(d)
		window.current_page = $("ul.pagination li.active").text()
		this
	add_item: (model) ->
		view = new SmartMerchant.SpAdminReportItemView
			model: model
		$(".main-container table",@$el).append(view.render().el)
