class window.AppVisit extends Backbone.Model
	url: "/mp/app_visit"
	parse: (resp)->
		if resp.status is 0
			resp.data