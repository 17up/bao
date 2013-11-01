class window.SmartMerchantAdmin.AgentManageListView extends SmartMerchant.View
	id: "agent_manage_list"
	template: JST['mp_admin/agent_manage_list']
	events:
		"click .new_agent": "new_agent"
		"ajax:success #search_mch_form": "search"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		@$el.html @template()
		this
	extra: ->
		$.get "/agents", (data) =>
			$("#agent_list").html JST["mp_admin/widget/agent_list_table"](pagination_str: data.data.pagination_str)
			@render_list data.data.agents
		super()
	render_list: (collection) ->
		$("#agent_list .table tbody").html ""
		for item in collection
			model = new AgentAccount(item)
			view = new SmartMerchantAdmin.AgentAccountItemView
				model: model
			$("#agent_list .table").append view.render().el
	new_agent: ->
		window.route.navigate("new_agent_account",true)
	search: (e,data) ->
		if data.status is 0
			$("#mch_list").html JST["mp_agent/widget/mch_list_table"](pagination_str: data.data.pagination_str)
			@render_list data.data.agents
		else
			alert data.msg
	paginate: (e,data) ->
		$("#agent_list").html JST["mp_admin/widget/agent_list_table"](pagination_str: data.data.pagination_str)
		@render_list data.data.agents
		this