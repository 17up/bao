class window.SmartMerchantAgent.OrderItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp_agent/homepage/order_item"]
	events:
		"click .check": "check"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	check: ->
		$.get "/orders/#{@model.get('id')}", (data) =>
			if data.status is 0
				$("#homepage").html JST["mp_agent/homepage/order_result"](data.data)