class window.AgentMoney extends Backbone.Model
	defaults:
		step: 1
	parse: (resp)->
		resp.data