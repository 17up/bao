class window.Property extends Backbone.Model
	defaults:
		step: 1
		push_number: 1000
	url: "/plan/personals/options"
	parse: (resp)->
		resp.data