class window.Consume extends Backbone.Model
	url: "/mp/consume"
	parse: (resp)->
		if resp.status is 0
			resp.data