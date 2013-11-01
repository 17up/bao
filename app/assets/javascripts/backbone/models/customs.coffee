class window.Customs extends Backbone.Model
	defaults:
		attr: "customs"
		step: 1
		has_upset: false
		push_number: 1
		push_title: "自定义名单推送"
		url_filter_user: "/plan/customs/filter_user"
		url_preview: "/plan/customs/preview"
		url_post: "/plan/customs"
		has_custom: true
	parse: (resp)->
		resp.data
