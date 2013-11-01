#= require_self
#= require ./routers/sm_router_admin

class window.SmartMerchantAdmin
	constructor: ->
		window.route = new SmartMerchantAdmin.Router()
		Backbone.history.start()
