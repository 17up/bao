# 指定商户触发推送
class window.SmartMerchantAdmin.Push5View extends SmartMerchantAdmin.Push1View
	id: "admin_push_5"
	model: new Merchants()
	type: "merchants"
	events:
		"change #mch_name":  "mch_name_select"
		"ajax:success #step_1": "step_1_success"
		"ajax:success #step_2": "step_2_success"
		"ajax:success #step_3": "step_3_success"
		"ajax:before #step_1": "step_1_before"
		"ajax:before #step_2": "step_2_before"
		"ajax:before #step_3": "step_3_before"
		"click .back_step_1": "back_step_1"
		"click .back_step_2": "back_step_2"
		"click .m-top": "move_top"
		"click .m-down": "move_down"
		"changeDate input[name='begin_date']": "change_begin_date"
		"changeDate input[name='end_date']": "change_end_date"
		"changeDate input[name='push_time[]']": "change_push_begin_time"
		"changeDate input[name='push_end_time[]']": "change_push_end_time"
		"click .set_rule": "set_rule"
		"keyup #push_content": "word_tip"
		"keyup .reply_content": "reply_content_tip"
		"click .set_default": "set_default"
		"valueChanged .spinEdit": "spinedit"
		"change input[name='has_upset']": "toggle_sms_upset"
		"click .add_sms_upset": "add_sms_upset"
	step_1_extra: ->
		super()
		$.get "/plan/merchants/new",(data) ->
			window.token = data.data.token
			$("form#step_1 input[name='token']").val window.token
	render_rule_detail: (bdv = $("#begin_date").val(),edv = $("#end_date").val()) ->
		number = $('#number-slider').slider("value")
		begin_date = $.date(bdv, "yyyy-MM-dd").adjust("D", -1)
		end_date = $.date(edv, "yyyy-MM-dd")
		days = (end_date.date() - begin_date.date())/(3600*1000*24)
		default_num = parseInt(number/(days*1000))
		default_mod = number%(days*1000)

		data = _.map [1..days],(i) =>
			f = begin_date.adjust("D", +1)
			if @model.get("push_number_perday")
				dn = @model.get("push_number_perday")[i-1]
			else
				dn = if i is days then default_num*1000 + default_mod else default_num*1000
			"date": f.format("yyyy-MM-dd")
			"weekday": f.format("dddd")
			"default": dn

		$("#hidden_rule").html JST['mp_admin/widget/time_rule'](rule_collection: data,number: number,no_limit: true)
		$(".spinEdit").spinedit
			minimum: 0
			maximum: @model.get("count")
			step: 1
		$(".set_datetime").datetimepicker
			format: 'yyyy-mm-dd hh:ii'
			language: "zh-CN"
			autoclose: true
			minuteStep: 10
			startView: 'day'
			maxView: 'day'
	change_push_begin_time: (e) ->
		$target = $(e.currentTarget).closest(".group-wrap")
		$dt = $("input[name='push_end_time[]']",$target).data("datetimepicker")
		time = e.date.getTime() - 8*3600*1000 + 10*60*1000
		$dt.setStartDate (new Date(time))
	change_push_end_time: (e) ->
		$target = $(e.currentTarget).closest(".group-wrap")
		$dt = $("input[name='push_time[]']",$target).data("datetimepicker")
		time = e.date.getTime() - 8*3600*1000 - 10*60*1000
		$dt.setEndDate (new Date(time))
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