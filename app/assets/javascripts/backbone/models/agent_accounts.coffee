class window.AgentAccounts extends Backbone.Model
	defaults:
		step: 1
	parse: (resp)->
		resp.data