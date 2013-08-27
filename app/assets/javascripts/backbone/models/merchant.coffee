class window.Merchant extends Backbone.Model
	defaults:
		"logo": "/logo.png"
		"mch_name": ""
		"mch_app_cate": ""
		"mch_app_label": ""
		"mch_info": ''
		"account": "veggie"
		"update_time": "1989-06-14"
		"store_cnt": "0"
	destroy: (success) ->
		super()
		$.get "/merchants/destroy?mch_id=" + @.get("mch_id"),(data) ->
			if data.status is 0
				success() if success