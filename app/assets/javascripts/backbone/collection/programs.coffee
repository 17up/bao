class window.SmartMerchant.Programs extends Backbone.Collection
	model: Program
	url: "/sp_reports"
	parse: (resp)->
		if resp.status is 0
			resp.data