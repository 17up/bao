class window.SmartMerchant.SpReportItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp/item/sp_report"]
	events:
		"click .check": "check"
		"click .edit": "edit"
		"click .stop": "stop"
		"click .check_sp_report": "check_sp_report"
		"click .check_sp_result": "check_sp_result"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	check: (e) ->
		$("#manage_list").html JST['mp/item/plan_detail'](@model.toJSON())
	edit: (e) ->
		this
	stop: (e) ->
		this
	check_sp_report: (e) ->
		id = @model.get("program_id")
		window.route.navigate("sp_reports/#{id}",true)
		this
	check_sp_result: (e) ->
		id = @model.get("market_id")
		window.route.navigate("sp_results/#{id}",true)
		this