#= require_self
#= require_tree ../collection
#= require_tree ../views/sm

class SmartMerchant.Router extends Backbone.Router
	routes:
		"": "home"
		"shop_cs": "shop_cs"
		"app_cs": "app_cs"
		"new_push": "new_push"
		"plan": "plan"
		"report": "report"
		"manage_list": "manage_list"
		"push_list": "push_list"
		"sp_reports/:id": "sp_report_detail"
		"sp_results/:id": "sp_result_detail"
		"sp_result": "sp_result"
		"property_push": "property_push"
		"custom_push": "custom_push"
		"new_app": "new_app"
		"app_push": "app_push"
		"homepage": "homepage"
		"month_analytics": "month_analytics"
		"package_info": "package_info"
	before_change: ->
		if window.route.active_view
			window.route.active_view.close()
	home: ->
		@navigate("homepage",true)
	app_cs: ->
		@before_change()
		new SmartMerchant.AppCsView()
	shop_cs: ->
		@before_change()
		new SmartMerchant.ShopCsView()
	new_push: ->
		@before_change()
		new SmartMerchant.NewPushView()
	plan: ->
		@before_change()
		new SmartMerchant.PlanView()
	report: ->
		@before_change()
		new SmartMerchant.ReportView()
	manage_list: ->
		@before_change()
		new SmartMerchant.ManageListView()
	push_list: ->
		@before_change()
		new SmartMerchant.PushListView()
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
	sp_result: ->
		@before_change()
		new SmartMerchant.SpResultView()
	property_push: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchant.PropertyPushView.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchant.PropertyPushView()
	custom_push: ->
		@before_change()
		if window.target_program
			EditPush = SmartMerchant.CustomPushView.extend
				model: window.target_program
			new EditPush()
		else
			new SmartMerchant.CustomPushView()
	new_app: ->
		@before_change()
		new SmartMerchant.NewAppView()
	app_push: ->
		@before_change()
		new SmartMerchant.AppPushView()
	homepage: ->
		@before_change()
		new SmartMerchant.HomepageView()
	month_analytics: ->
		@before_change()
		new SmartMerchant.MonthAnalyticsView()
	package_info: ->
		@before_change()
		new SmartMerchant.PackageInfoView()
