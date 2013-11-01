class window.SmartMerchantAdmin.HomepageView extends SmartMerchant.View
	id: "homepage"
	template: JST['mp_admin/home_page']
	render: ->
		@$el.html @template()
		this
