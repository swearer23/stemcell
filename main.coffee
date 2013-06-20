###global requirejs,define
###

requirejs.config
	paths:
		backbone : 'lib/backbone'
		underscore: 'lib/underscore'
		$ : 'lib/jquery-1.8.2.min'
		stemcell : 'lib/stemcell'
		appConfig : 'config/AppConfig'
		appRouter : 'config/router'
	shim:
		$ :
			exports : '$'
		backbone :
			deps : ['$' , 'underscore']
			exports : 'Backbone'
		stemcell :
			deps: ['$' , 'backbone']
			exports: 'Stemcell'
		appConfig :
			deps : ['stemcell']
			exports : 'AppConfig'

requirejs ['$' , 'underscore' , 'backbone' , 'stemcell'], ()->
	require ['appConfig'] , () ->
		exts = []
		for k , v of AppConfig.Stemcell
			exts.push(v)
		require exts , () ->
			require ['appRouter'] , () ->

