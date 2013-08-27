class window.SmartMerchant.Reports extends Backbone.Collection
	model: Plan
	url: "/mp/report_list"
	parse: (resp)->
		if resp.status is 0
			resp.data