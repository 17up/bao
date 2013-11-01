class window.SmartMerchantAgent.AddMoneyItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp_agent/add_money/am_item"]
	events:
		"change .package": "update"
		"valueChanged .spinEdit": "spinedit"
		"click .delete": "delete"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	update: (e) ->
		id = $(e.currentTarget).val()
		count = @$el.find('.spinEdit').val()
		$.get "/packages/#{id}/cal_total_price",count: count, (d) =>
			@$el.find("span.amount").text d.data
			@model.trigger "change"
		this
	spinedit: (e) ->
		@$el.find(".package").trigger "change"
	delete: ->
		if confirm("您确定要删除该订单么？")
			@$el.remove()
			@model.trigger "change"
		else
			false