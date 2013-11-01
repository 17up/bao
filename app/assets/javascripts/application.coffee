#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require twitter/bootstrap
#= require hamlcoffee
#= require underscore
#= require backbone
#= require_tree ./lib
#= require_tree ./templates
#= require_tree ./backbone/models
#= require ./backbone/sm
#= require ./backbone/sm_agent
#= require ./backbone/sm_admin


$ ->
	$("a[rel=popover]").popover()
	$(".tooltip").tooltip()
	$("a[rel=tooltip]").tooltip()
	$init = $("#init")
	Highcharts.setOptions
		lang:
			resetZoom: "复原"
			printChart: "打印图表"
			downloadJPEG: "下载 jpeg 图片"
			downloadPDF: "下载 pdf 文档"
			downloadPNG: "下载 png 图片"
			downloadSVG: "下载 svg 矢量图片"
	if $init.length is 1
		js_class = $init.data().js
		new window[js_class]



