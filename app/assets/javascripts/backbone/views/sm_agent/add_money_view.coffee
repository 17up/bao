class window.SmartMerchantAgent.AddMoneyView extends SmartMerchant.View
	id: "add_money"
	className: "detail"
	template: JST['mp_agent/add_money']
	model: new AgentMoney()
	events:
		"click .cancel": "cancel"
		"ajax:success #add_money_form": "success_money"
		"click .back": "back"
	initialize: ->
		super()
		if window.mch_selected
			@step_1_extra()
		else
			@cancel()
	render: ->
		@$el.html @template(@model.toJSON())
		this
	step_1_extra: ->
		$.get "/packages/added", (data) =>
			collection =  _.map data.data, (d) ->
				[d.id,d.name]

			for item in window.mch_selected
				data = _.extend item,packages: collection
				model = new AgentMchMoney(data)
				view = new SmartMerchantAgent.AddMoneyItemView
					model: model
				@listenTo model, 'change', @update_sm
				$("#mt_1").append view.render().el
			$(".spinEdit").spinedit
				minimum: 1
				maximum: 50
				step: 1
	update_sm: ->
		$form = @$el.find("form")
		if $("span.amount",$form).length > 0
			map = _.map $("span.amount",$form), (e) ->
				Number $(e).text()
			data = _.reduce map,(memo,num) ->
				memo + num
		else
			data = 0
		$("span.count_num").text Number(data).toFixed(2)
	cancel: ->
		window.route.navigate("mch_manage_list",true)
	success_money: (e,data) ->
		if data.status is 0
			@$el.html JST["mp_agent/add_money/order_result"](data.data)
		else
			alert data.msg
	back: ->
		window.route.navigate('mch_manage_list',true)