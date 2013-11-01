class window.SmartMerchantAdmin.AgentAccountItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp_admin/item/agent_item"]
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
		window.route.navigate("agent_detail/#{id}",true)
		this
	freeze: ->
		id = @model.get("id")
		if confirm("您确定要冻结本代理么？")
			$.post "/agents/#{id}/freeze_agent", (data) =>
				if data.status is 0
					@model.set data.data
				else
					alert data.msg
		this
	recover: ->
		id = @model.get("id")
		if confirm("您确定要恢复本代理么？")
			$.post "/agents/#{id}/restore_agent", (data) =>
				if data.status is 0
					@model.set data.data
				else
					alert data.msg
		this