# 自定义名单推送
class window.SmartMerchantAdmin.Push4View extends SmartMerchantAdmin.Push1View
	id: "admin_push_4"
	model: new Customs()
	type: "customs"
	step_1_extra: ->
		super()
		$.get "/plan/customs/new",(data) ->
			window.token = data.data.token
			$("form#step_1 input[name='token']").val window.token
		# $form = $("#step_1")
		# authenticity_token = $("meta[name='csrf-token']").attr('content')
		# $form.prepend "<input name='authenticity_token' type='hidden' value='#{authenticity_token}'>"
	step_1_success: (e,data) ->
		data = _.extend data.data,step: 2
		@model.set data
		@step_2_extra(1,@model.get("count"),1)
		this
	step_1_before: (e) ->
		Utils.loading $(e.currentTarget)
		$form = $(e.currentTarget)
		if $("input[type='file']",$form).val() is ""
			alert "请选择一个文件上传"
			Utils.loaded $(e.currentTarget)
			return false
		if $("input[name='store_id']:checked",$form).length > 0
			true
		else
			alert("请先选择一家门店")
			Utils.loaded $(e.currentTarget)
			return false