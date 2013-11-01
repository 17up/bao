class window.News extends Backbone.Model
	defaults:
		attr: "news"
		step: 1
		has_upset: false
		push_number: 1
		push_title: "潜在客户推送"
		url_filter_user: "/plan/news/filter_user"
		url_preview: "/plan/news/preview"
		url_post: "/plan/news"
	parse: (resp)->
		resp.data
