class window.SmartMerchantAgent.MchManageListView extends SmartMerchant.View
	id: "mch_manage_list"
	template: JST['mp_agent/mch_manage_list']
	events:
		"click .new_mch": "new_mch"
		"click .add_money": "add_money"
		"click .toggle": "toggle"
		"ajax:success #search_mch_form": "search"
		"ajax:success a[data-remote=true]": "paginate"
	render: ->
		@$el.html @template()
		this
	extra: ->
		$.get "/merchants/list", (data) =>
			$("#mch_list").html JST["mp_agent/widget/mch_list_table"](pagination_str: data.data.pagination_str)
			@render_list data.data.merchants
		super()
	render_list: (collection) ->
		$("#mch_list .table tbody").html ""
		for item in collection
			model = new AgentMerchant(item)
			view = new SmartMerchantAgent.MchAccountItemView
				model: model
			$("#mch_list .table").append view.render().el
	new_mch: ->
		window.route.navigate("new_mch_account",true)
	add_money: ->
		$checked = $("input[name='mch_selected[]']:checked")
		if $checked.length > 0
			window.mch_selected = _.map $checked, (e) ->
				id: $(e).val()
				name: $.trim($(e).parent().next().text())

			window.route.navigate("add_money",true)
		else
			alert "请先勾选要充值的商户，进行充值！"
	toggle: (e) ->
		c = $(e.currentTarget).attr("checked") is "checked"
		$("input[name='mch_selected[]']").attr "checked",c
	search: (e,data) ->
		if data.status is 0
			$("#mch_list").html JST["mp_agent/widget/mch_list_table"](pagination_str: data.data.pagination_str)
			@render_list data.data.merchants
		else
			alert data.msg
	paginate: (e,data) ->
		$("#mch_list").html JST['mp_agent/widget/mch_list_table'](pagination_str: data.data.pagination_str)
		@render_list data.data.merchants
		this