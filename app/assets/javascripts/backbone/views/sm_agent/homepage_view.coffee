class window.SmartMerchantAgent.HomepageView extends SmartMerchant.View
	id: "homepage"
	template: JST['mp_agent/home_page']
	events:
		"click .add_money": "add_money"
		"ajax:before #add_money_form": "before_add_money"
		"ajax:success #add_money_form": "success_add_money"
		"click .back": "back"
		"ajax:success #top_filter": "filter"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		@$el.html @template()
		$.get "/orders",(data) =>
			$("#agent_summary span.money").text data.data.amount
			$("#agent_order_list").html JST['mp_agent/homepage/order_list'](pagination_str: data.data.pagination_str)
			@render_orders(data.data.orders)
		this
	render_orders: (orders) ->
		$("#agent_order_list .table tbody").html ""
		for item in orders
			model = new AgentOrder(item)
			view = new SmartMerchantAgent.OrderItemView
				model: model
			$("#agent_order_list .table").append view.render().el
	extra: ->
		datetime_options =
			format: 'yyyy-mm-dd'
			language: "zh-CN"
			minView: 'month'
			autoclose: true
			# startDate: $.date().adjust("D", +1).date()
			# endDate: $.date().adjust("D", +30).date()
		$(".date input").datetimepicker datetime_options

	add_money: ->
		$("#add_money_modal").modal("show")
		this
	success_add_money: (e,d) ->
		$("#add_money_modal").modal("hide")
		@$el.html JST["mp_agent/order_result"](d.data)
		this
	before_add_money: (e) ->
		$target = $(e.currentTarget).find("input.num")
		if Number($target.val()) is 0
			alert "充值金额不能为0"
			return false
		if Number($target.val()) > 99999999
			alert "充值金额不能超过8位数"
			return false
	back: ->
		@render()
	filter: (e,data) ->
		if data.status is 0
			@render_orders(data.data.orders)
	paginate: (e,data) ->
		$("#agent_order_list").html JST['mp_agent/homepage/order_list'](pagination_str: data.data.pagination_str)
		@render_orders(data.data.orders)
		this