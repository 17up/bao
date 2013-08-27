class window.SpReport extends Backbone.Model
	parse: (resp)->
		if resp.status is 0
			resp.data