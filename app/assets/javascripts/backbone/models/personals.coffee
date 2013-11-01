class window.Personals extends Backbone.Model
	defaults:
		attr: "personals"
		step: 1
		has_upset: false
		push_number: 1
		push_title: "个性化筛选推送"
		url_filter_user: "/plan/personals/filter_user"
		url_preview: "/plan/personals/preview"
		url_post: "/plan/personals"
		has_options: true
	url: "/plan/personals/new"
	parse: (resp)->
		resp.data
