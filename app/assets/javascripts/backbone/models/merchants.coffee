class window.Merchants extends Backbone.Model
	defaults:
		attr: "merchants"
		step: 1
		has_upset: false
		push_number: 1
		push_title: "指定商户触发推送"
		url_filter_user: "/plan/merchants/filter_user"
		url_preview: "/plan/merchants/preview"
		url_post: "/plan/merchants"
		has_merchant: true
		no_limit: true
	parse: (resp)->
		resp.data
