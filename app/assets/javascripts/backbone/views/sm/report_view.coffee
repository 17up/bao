class window.SmartMerchant.ReportView extends SmartMerchant.View
	id: "report"
	template: JST['mp/report']
	collection: new SmartMerchant.Reports()
	add_one: (model) ->
		ReportItemView = SmartMerchant.PlanItemView.extend 
			template: JST["mp/item/report"]
		view = new SmartMerchant.ReportItemView	
			model: model 
		$(".main-container .table",@$el).append(view.render().el)
	render: ->
		template = @template()
		@$el.html(template)
		@collection.fetch
			success: (data) =>
				for d in data.models
					@add_one(d)	
		this