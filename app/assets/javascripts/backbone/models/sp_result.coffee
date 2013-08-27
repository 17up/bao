class window.SpResult extends Backbone.Model
	parse: (resp)->
		if resp.status is 0
			resp.data