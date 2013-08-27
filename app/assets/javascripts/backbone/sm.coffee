#= require_self
#= require ./routers/sm_router

class window.SmartMerchant
	constructor: ->
		window.route = new SmartMerchant.Router()
		Backbone.history.start()

		# adjust_copyright = ->
		# 	height = $("#article").height() + 80
		# 	if $(window).height() - height > 0
		# 		$(".copyright").addClass "fix_bot"
		# 	else
		# 		$(".copyright").removeClass "fix_bot"
		# 	$(".copyright").fadeIn()
		# $(window).resize ->
		# 	adjust_copyright()
		# setTimeout(->
		# 	adjust_copyright()
		# ,1000)		
		# $(document).on "click","a,span", ->
		# 	$(".copyright").hide()
		# 	$(window).resize()

			