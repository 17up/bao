#= require_self
#= require ./routers/sm_router_agent

class window.SmartMerchantAgent
	constructor: ->
		window.route = new SmartMerchantAgent.Router()
		Backbone.history.start()
