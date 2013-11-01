# 个性化筛选推送
class window.SmartMerchantAdmin.Push3View extends SmartMerchantAdmin.Push1View
	id: "property_push"
	model: new Personals()
	type: "personals"
	initialize: ->
		@listenTo(@model, 'change', @render)
		$("#side_nav li a[href='#" + @id + "']").parent().addClass('active')
		if window.target_program
			program_id = window.target_program.get('program_id')
			$.get "/plan/#{window.target_program.get('attr')}/#{program_id}/edit",(data) =>
				data = _.extend data.data,program_id: program_id,has_upset: true
				@model.set data
				$("#article").html(@render().el)

				@step_2_extra(1,@model.get("count"),1)
				$("#push_content").trigger "keyup"
				if @model.get("reply_code").length > 1
					$(".upset_container .item_list").html("")
					for code,i in @model.get("reply_code")
						$(".upset_container .item_list").append JST['mp_admin/push_1/sms_upset_item'](reply_code: code,reply_content: @model.get("reply_content")[i])
				$(".reply_content").trigger "keyup"
		else
			@model.fetch
				success: (data) =>
					$("#article").html(@render().el)
					@step_1_extra()
		window.route.active_view = this
	step_1_extra: ->
		super()
		window.token = @model.get("token")
		$("form#step_1 input[name='token']").val window.token
