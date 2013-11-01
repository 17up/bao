class window.SmartMerchantAgent.MchAccountItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp_agent/mch_item"]
	events:
		"click .manage": "manage"
		"click .freeze": "freeze"
		"click .recover": "recover"
	initialize: ->
		@listenTo(@model, 'change', @render)
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	manage: ->
		id = @model.get("id")
		window.route.navigate("mch_detail/#{id}",true)
		this
	freeze: ->
		id = @model.get("id")
		if confirm("您确定要冻结本商户么？")
			$.post "/merchants/#{id}/freeze_merchant", (data) =>
				if data.status is 0
					@model.set data.data
				else
					alert data.msg
		this
	recover: ->
		id = @model.get("id")
		if confirm("您确定要恢复本商户么？")
			$.post "/merchants/#{id}/restore_merchant", (data) =>
				if data.status is 0
					@model.set data.data
				else
					alert data.msg
		this