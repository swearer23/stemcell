Stemcell.sync = Backbone.sync = (method, model, options)->
	if model.url is undefined
		throw new Error('tinymobi: url in not defined!')
	params = {}
	params.url = TinymobiConfig.host + model.url
	params.type = 'POST'
	params.dataType = 'json'
	if(method is 'create' || method is 'update')
		params.data = model.toJSON()
	options.error = (xhr, errorType, error)->
		#location.href = "/"
			#options.complete = (xhr, status)->
	$.ajax(_.extend(params, options))
