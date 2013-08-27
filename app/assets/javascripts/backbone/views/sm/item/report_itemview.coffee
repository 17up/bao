class window.SmartMerchant.ReportItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp/item/report"]
	events:
		"click .detail": "detail"
	detail: ->
		plan_id = @model.get("plan_id")
		if plan_id is ""
			Utils.flash("无法找到报告","error",$(".main"))
		else
			$.get "/mp/report?id=" + plan_id,(data) ->
				if data.status is 0
					template = JST["mp/report_detail"](data.data)
					$(".main").html(template)
		this
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this