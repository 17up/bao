class window.SmartMerchant.View extends Backbone.View
	initialize: ->
		$("#side_nav li a[href='#" + @id + "']").parent().addClass('active')
		$("#article").html(@render().el)
		window.route.active_view = this
		@extra()
	close: ->
		$("#side_nav li a[href='#" + @id + "']").parent().removeClass('active')
	extra: ->
		false