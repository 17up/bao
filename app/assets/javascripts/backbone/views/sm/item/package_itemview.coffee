class window.SmartMerchant.PackageItemView extends Backbone.View
	tagName: "tr"
	template: JST["mp/item/package"]
	events:
		"click .detail": "detail"
	detail: ->
		switch @model.get("type")
			when "month"
				window.route.navigate("month_analytics",true)
			when "app"
				window.route.navigate("new_app",true)
			when "custom"
				$.get "/merchants/info",type: "custom",(data) ->
					if data.status is 0
						data = _.extend data.data,name: "自定义名单短信"
						$("#package_info").html JST["mp/package_info/detail"](data)
					else
						alert data.msg
			when "personal"
				$.get "/merchants/info",type: "personal",(data) ->
					if data.status is 0
						data = _.extend data.data,name: "个性化筛选短信"
						$("#package_info").html JST["mp/package_info/detail"](data)
					else
						alert data.msg
		this
	render: ->
		template = @template(@model.toJSON())
		@$el.html(template)
		this