class window.SmartMerchant.PlanView extends SmartMerchant.View
	id: "plan"
	template: JST['mp/plan']
	collection: new SmartMerchant.Plans()
	events:
		"click .back": "back"
	add_one: (model) ->
		view = new SmartMerchant.PlanItemView
			model: model 
		$(".main-container .table",@$el).append(view.render().el)
	back: ->
		@render()
		this
	render: ->
		table_ths = [
			[
				"方案名称",
				"推送数量",
				"推送时间",
				"方案提交时间",
				"方案状态",
				"查看"
			]
		]
		template = @template(ths: table_ths)
		@$el.html(template)
		@collection.fetch
			success: (data) =>
				for d in data.models
					@add_one(d)	
		this	
	