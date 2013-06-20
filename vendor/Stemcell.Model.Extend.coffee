Stemcell.Model.prototype.baseFetch = (options) ->
	options = _.clone(options) or {}
	model = this
	success = options.success
	options.success = (resp, status, xhr) ->
		if (success)
			success(model, resp, options)
	return this.sync('read', this, options)

Stemcell.Model.prototype.baseSave = (key, val, options) ->
	done = false
	if key == null || _.isObject(key)
		attrs = key
		options = val
	else if key != null
		(attrs = {})[key] = val
	options = _.clone(options) or {}
	if options.wait
		if (!this._validate(attrs, options))
			return false
	current = _.clone(this.attributes)

	silentOptions = _.extend({}, options, {silent: true})
	if options.wait
		waitOption = silentOptions
	else
		waitOption = options
	if attrs && !this.set(attrs, waitOption)
		return false
	if !attrs && !this._validate(null, options)
		return false

	model = @
	success = options.success
	options.success = (resp, status, xhr) ->
		done = true
		serverAttrs = model.parse(resp, xhr)
		if (options.wait)
			serverAttrs = _.extend(attrs || {}, serverAttrs)
		if (success)
			success(model, resp, options)

	if @.isNew()
		method = 'create'
	else
		method = 'update'
	xhr = @.sync(method , this, options)

	if !done && options.wait
		@.clear(silentOptions)
		@.set(current, silentOptions)
	return xhr

Stemcell.Collection.prototype.baseFetch = (options) ->
	if options
		options = _.clone(options)
	else
		options = {}
	if options.parse == 0
		options.parse = true
	collection = this
	success = options.success
	options.success = (resp, status, xhr) ->
		if success
			success(collection, resp, options)
	return this.sync('read', this, options)
