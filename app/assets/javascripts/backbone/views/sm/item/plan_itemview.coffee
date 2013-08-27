class window.SmartMerchant.PlanItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp/item/plan"]
	detal_template: JST["mp/plan_detail"]
	events:
		"click .detail": "detail"
	detail: ->	
		view = @detal_template(@model.toJSON())
		$("#plan").html(view)
		Utils.chart1($("#plan .chart1"),@model.get("trigger_num"),@model.get("active_rt_num"),@model.get("active_nw_num"))
		this
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this