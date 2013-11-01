class window.Returns extends Backbone.Model
	defaults:
		attr: "returns"
		step: 1
		has_upset: false
		push_number: 1
		push_title: "老客户推送"
		url_filter_user: "/plan/returns/filter_user"
		url_preview: "/plan/returns/preview"
		url_post: "/plan/returns"
	parse: (resp)->
		resp.data
