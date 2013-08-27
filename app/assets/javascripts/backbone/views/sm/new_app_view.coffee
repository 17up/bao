class window.SmartMerchant.NewAppView extends SmartMerchant.View
	id: "new_app"
	template: JST['mp/new_app']
	render: ->
		template = @template()
		@$el.html(template)
		this