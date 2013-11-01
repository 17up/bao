class window.SmartMerchant.PushProgramView extends SmartMerchant.View
	validate_date: ->
		$err_tip = $("#begin_date").closest(".field").find(".err_tip")
		bdv = $("#begin_date").val()
		edv = $("#end_date").val()
		if bdv is ''
			$err_tip.text "请选择开始日期"
			return false
		else if edv is ''
			$err_tip.text "请选择结束日期"
			return false
		else
			$err_tip.text ""
	validate_title: (e) ->
		$title = $(e.currentTarget).find(".title")
		title_length = $.trim($("input",$title).val()).length
		if title_length < 4 or 	title_length > 25
			$(".err_tip",$title).text "您输入的方案名称有误，请重新输入"
			return false
		else
			$(".err_tip",$title).text ""
	validate_content: (e) ->
		$textarea = $(e.currentTarget).find(".form_textarea")
		if $("textarea[name='push_content']",$textarea).val() is ''
			$(".err_tip2",$textarea).text "请输入短信文案"
			return false
		else
			$(".err_tip2",$textarea).text ""
	textarea_limit: ($ta,limit = 128) ->
		$tip = $ta.next()
		num = $ta.val().length
		# if num > limit
		# 	$ta.val $ta.val().substr(0, limit)
		# 	return
		# wcnt = limit - num
		$(".num3",$tip).text num
		# $(".num3",$tip).text wcnt
		if num > 0
			if num%64 is 0
				num2 = num/64
			else
				num2 = parseInt(num/64) + 1
		else
			num2 = 0
		$(".num2",$tip).text num2
		num2
	word_tip: (e) ->
		@per_number = @textarea_limit $(e.currentTarget)
	change_begin_date: (e) ->
		$dt = $("input[name='end_date']").data("datetimepicker")
		$dt.setStartDate e.date
		# 30 days
		#$dt.setEndDate new Date(e.date.getTime() + 30*24*3600*1000)
	change_end_date: (e) ->
		$dt = $("input[name='begin_date']").data("datetimepicker")
		$dt.setEndDate e.date
		# 30 days
		#$dt.setStartDate new Date(e.date.getTime() - 30*24*3600*1000)
	setup_date_picker: ->
		datetime_options =
			format: 'yyyy-mm-dd'
			language: "zh-CN"
			minView: 'month'
			autoclose: true
			startDate: $.date().adjust("D", +1).date()
			endDate: $.date().adjust("D", +30).date()
		$(".date input").datetimepicker datetime_options
