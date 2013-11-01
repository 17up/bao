#= require_self
#= require_tree ../collection
#= require_tree ../views/sm
#= require_tree ../views/sm_agent

class SmartMerchantAgent.Router extends Backbone.Router
	routes:
		"": "home"
		"homepage": "homepage"
		"new_mch_account": "new_mch_account"
		"mch_manage_list": "mch_manage_list"
		"mch_detail/:id": "mch_detail"
		"add_money": "add_money"
	before_change: ->
		if window.route.active_view
			window.route.active_view.close()
	home: ->
		@navigate("homepage",true)
	homepage: ->
		@before_change()
		new SmartMerchantAgent.HomepageView()
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
	add_money: ->
		@before_change()
		new SmartMerchantAgent.AddMoneyView()
