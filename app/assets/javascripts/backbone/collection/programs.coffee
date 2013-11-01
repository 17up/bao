class window.SmartMerchant.Programs extends Backbone.Collection
	model: Program
	url: "/sp_reports"
	parse: (resp)->
		if resp.status is 0
			@pagination_str = resp.data.pagination_str
			resp.data.programs