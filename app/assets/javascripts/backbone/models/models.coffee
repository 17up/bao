class window.Models extends Backbone.Model
	defaults:
		attr: "models"
		step: 1
		has_upset: false
		push_number: 1
		push_title: "模型触发推送"
		url_filter_user: "/plan/models/filter_user"
		url_preview: "/plan/models/preview"
		url_post: "/plan/models"
		no_limit: true
	parse: (resp)->
		resp.data
