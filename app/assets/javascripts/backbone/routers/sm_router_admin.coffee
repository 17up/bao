#= require_self
#= require_tree ../collection
#= require_tree ../views/sm
#= require_tree ../views/sm_agent
#= require_tree ../views/sm_admin


class SmartMerchantAdmin.Router extends Backbone.Router
	routes:
		"": "home"
		"homepage": "homepage"
		"manage_list": "manage_list"
		"sp_reports/:id": "sp_report_detail"
		"sp_results/:id": "sp_result_detail"
		"admin_push_1": "admin_push_1"
		"admin_push_2": "admin_push_2"
		"property_push": "admin_push_3"
		"admin_push_4": "admin_push_4"
		"admin_push_5": "admin_push_5"
		"admin_push_6": "admin_push_6"
		"new_mch_account": "new_mch_account"
		"mch_manage_list": "mch_manage_list"
		"mch_detail/:id": "mch_detail"
		"add_money": "add_money"
		"agent_manage_list": "agent_manage_list"
		"new_agent_account": "new_agent_account"
		"agent_detail/:id": "agent_detail"
	before_change: ->
		if window.route.active_view
			window.route.active_view.close()
	home: ->
		@navigate("homepage",true)
	homepage: ->
		@before_change()
		new SmartMerchantAdmin.HomepageView()
	manage_list: ->
		@before_change()
		new SmartMerchantAdmin.ManageListView()
	sp_report_detail: (id) ->
		@before_change()
		SpView = SmartMerchant.SpReportView.extend
			mod_id: id
		new SpView()
	sp_result_detail: (id) ->
		@before_change()
		SpView = SmartMerchant.SpResultView.extend
			mod_id: id
		new SpView()
	admin_manage_list: ->
		@before_change()
		new SmartMerchantAdmin.ManageListView()
	admin_push_1: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchantAdmin.Push1View.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchantAdmin.Push1View()
	admin_push_2: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchantAdmin.Push2View.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchantAdmin.Push2View()
	admin_push_3: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchantAdmin.Push3View.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchantAdmin.Push3View()
	admin_push_4: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchantAdmin.Push4View.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchantAdmin.Push4View()
	admin_push_5: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchantAdmin.Push5View.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchantAdmin.Push5View()
	admin_push_6: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchantAdmin.Push6View.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchantAdmin.Push6View()
	# agent
	new_mch_account: ->
		@before_change()
		new SmartMerchantAgent.NewMchAccountView()
	mch_manage_list: ->
		@before_change()
		new SmartMerchantAgent.MchManageListView()
	mch_detail: (id) ->
		@before_change()
		MD = SmartMerchantAgent.MchDetailView.extend
			mch_id: id
		new MD()
	agent_detail: (id) ->
		@before_change()
		AD = SmartMerchantAdmin.AgentDetailView.extend
			agent_id: id
		new AD()
	add_money: ->
		@before_change()
		new SmartMerchantAgent.AddMoneyView()
	agent_manage_list: ->
		@before_change()
		new SmartMerchantAdmin.AgentManageListView()
	new_agent_account: ->
		@before_change()
		new SmartMerchantAdmin.NewAgentAccountView()
