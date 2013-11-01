class window.SmartMerchant.NewAppView extends SmartMerchant.View
	id: "new_app"
	template: JST['mp/new_app']
	render: ->
		template = @template()
		@$el.html(template)
		this
	extra: ->
		$.get "/api/store2merchant/weidian", (data) ->
			$(".iframe_wrap").html JST['mp/app/iframe'](data.data)
		super()
