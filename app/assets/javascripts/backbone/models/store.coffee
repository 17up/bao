class window.Store extends Backbone.Model
	defaults:
		"store_name": ""
		"store_address": ""
		"store_province": ""
		"store_city": ""
		"store_region": ''
		"update_time": "1989-06-14"
		"store_mid": ""
	destroy: (success) ->
		super()
		$.get "/merchants/destroy_store?store_id=" + @.get("store_id"),(data) ->
			if data.status is 0
				success() if success