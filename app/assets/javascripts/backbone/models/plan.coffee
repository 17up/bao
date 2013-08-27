class window.Plan extends Backbone.Model
	defaults:
		"status": ""
		"merchant_name": ""
		"plan_name": ""
		"apply_account": ""
		"plan_id": ""
		"active_begin": ''
		"active_end": ''
		"content": ""
		"number": 1000
		"preview": false
	url: "/mp/save_plan"
