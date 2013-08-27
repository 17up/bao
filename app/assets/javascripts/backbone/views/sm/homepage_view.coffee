class window.SmartMerchant.HomepageView extends SmartMerchant.View
	id: "homepage"
	template: JST['mp/home_page']
	render: ->
		template = @template()
		@$el.html(template)
		this