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
		$.get "/sp_reports/#{@model.get('program_id')}/program", (data) ->
			$("#manage_list").html JST['mp/item/plan_detail'](data.data)
	edit: (e) ->
		window.target_program = @model
		switch @model.get("p_type")
			when 5
				opts =
					step: 2
					attr: "personals"
				params = _.extend Personals.prototype.defaults,opts
				window.target_program.set params
				window.route.navigate("property_push",true)
			when 4
				window.route.navigate("custom_push",true)
			when 7
				opts =
					step: 2
					attr: "returns"
				params = _.extend Returns.prototype.defaults,opts
				window.target_program.set params
				window.route.navigate("admin_push_1",true)
			when 8
				opts =
					step: 2
					attr: "news"
				params = _.extend News.prototype.defaults,opts
				window.target_program.set params
				window.route.navigate("admin_push_2",true)
			when 6
				opts =
					step: 2
					attr: "customs"
				params = _.extend Customs.prototype.defaults,opts
				window.target_program.set params
				window.route.navigate("admin_push_4",true)
			when 9
				opts =
					step: 2
					attr: "merchants"
				params = _.extend Merchants.prototype.defaults,opts
				window.target_program.set params
				window.route.navigate("admin_push_5",true)
			when 10
				opts =
					step: 2
					attr: "models"
				params = _.extend Models.prototype.defaults,opts
				window.target_program.set params
				window.route.navigate("admin_push_6",true)
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