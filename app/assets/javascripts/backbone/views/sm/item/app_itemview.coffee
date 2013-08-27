class window.SmartMerchant.AppItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp/item/app"]
	events:
		"click .check": "check"
		"click .edit": "edit"
		"click .check_report": "check_report"
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this
	check: (e) ->
		this
	edit: (e) ->
		this
	check_report: (e) ->
		this
