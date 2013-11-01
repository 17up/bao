class window.SmartMerchant.PackageInfoView extends SmartMerchant.View
	id: "package_info"
	template: JST['mp/package_info']
	events:
		"click .back": "back"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		@$el.html @template()
		$.get "/merchants/info_for_package",(data) =>
			if data.status is 0
				for item in data.data
					model = new PackageItem(item)
					@addOne(model)
		this
	addOne: (model) ->
		view = new SmartMerchant.PackageItemView
			model: model
		$(".table",@$el).append view.render().el
	back: ->
		@render()
	paginate: (e,data) ->
		if data.status is 0
			data = _.extend data.data,name: $(".nav-bar span.text:last").text()
			$("#package_info").html JST["mp/package_info/detail"](data)
		else
			alert data.msg