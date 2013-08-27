class window.SmartMerchant.Plans extends Backbone.Collection
	model: Plan
	url: "/mp/plan_list"
	parse: (resp)->
		if resp.status is 0
			resp.data