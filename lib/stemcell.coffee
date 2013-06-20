(
	() ->
		#
		#	general methods for design pattern
		#
		#

		root = @
		if(typeof exports != 'undefined')
			Stemcell = exports
		else
			Stemcell = root.Stemcell = {}

		Backbone = root.Backbone
		if !Backbone && typeof require != 'undefined'
			Backbone = require 'backbone'
		Stemcell.history = Backbone.history
		Stemcell.sync = Backbone.sync
		Stemcell.setEmulateJSON = (option) ->
			Backbone.emulateJSON = option
		
		Stemcell.setEmulateHTTP = (option) ->
			Backbone.emulateHTTP = option

		log = (object) ->
			if typeof console != 'undefined'
				console.log object

		error = (object) ->
			throw object

		class Stemcell.View extends Backbone.View
			constructor			: ->
				@staticEl = @el
				super
				@initialize.apply(@ , arguments)
				@init()
				@ensureEl()
			staticEl			: null
			dom				: null
			init				: ->
			setTemplate			: (templateString , args) ->
				args = args or {}
				@template = _.template(templateString , args)
			fire : (evt , options) ->
				@onFireEvent(evt , options)
			onFireEvent			: (evt) ->
				##
				#	leave it a empty method
				#	until messenger to which this view belongs
				#	bind a onFireEvent handler to it
				#
				#	otherwise whenever this view fires an event
				#	then nothing is gonna happen
				##
			dispose				: =>
				for k , v of @events
					selector = k.split(' ')[1]
					@$el.find(selector).off()
				if @dom and @dom.remove
					$(@dom).remove()
			ensureEl			: ->
				_this = @
				@afterRender = @render
				@render = () ->
					@$el = $(@staticEl)
					@afterRender.apply(@ , arguments)
					@setRelatedDom()
			setRelatedDom		: ->
				#
				#	due to some reasons, DOM elements appended to document by method 'render'
				#	cannot be found efficiently
				#
				#	SO, may this be a TODO
				#	when something better comes up, we could take the advantage of remove() from JQuery in order to remove
				#	the DOM elements and the events that are bound to it
				#


		class Stemcell.Router extends Backbone.Router
			setMessengers : (messengerClass) ->
				if !_.has(window , 'ribosome')
					this.ribosome = window.ribosome = @ribosome = Stemcell.Ribosome.getInstance()
				for k , v of messengerClass
					@[k] = new v
					@ribosome.pushMessenger @[k] , @ribosome.documentMessenger
			call : ->
				@ribosome.documentMessenger.call.apply(@ , arguments)
				

		class Stemcell.Ribosome
			@getInstance : ->
				if !@instance
					@instance = new @
					@instance.init()
				@instance
			messengers : {}
			tree : {}
			init : ->
				@pushMessenger(Stemcell.DocumentMessenger.getInstance())
				@documentMessenger = @messengers.messenger_1.messenger
				@
			pushMessenger : (messenger , parent) ->
				if messenger instanceof Stemcell.Messenger
					uid = @getID()
					mid = 'messenger_' + uid
					messenger.mid = mid
					@messengers[mid] = {uid : uid , messenger : messenger}
					@buildTree(@messengers[mid].messenger , parent)
					mid
			getMessenger : (key) ->
				if not (key instanceof Array)
					try
						return @messengers[key].messenger
					catch err
						alert key
				else
					messengers = []
					for k in key
						messengers.push(@messengers[k].messenger)
					messengers
			getParentMessengerByMid : (mid) ->
				self = @tree[mid]
				@getMessenger(self.parent)
			getChildrenMessengerByMid : (mid) ->
				children = _.filter @tree, (m) -> m.parent == mid
				children = _.map children , (c) => @messengers[c.mid]
			buildTree : (messenger , parent) ->
				if parent
					_m =
						mid : messenger.mid
						parent : parent.mid
				else
					_m =
						mid : messenger.mid
						parent : 'messenger_0'
				@tree[messenger.mid] = _m
			getLevel : (mid) ->
				self = @tree[mid]
				level = 0
				while parent != 0
					parent = @tree[self.parent].mid
					level += 1
					self = parent
				level
			removeMessengerByMid : (mid) ->
				children = @getChildrenMessengerByMid(mid)
				for c in children
					c.messenger.dispose()
				@messengers[mid] = null
				delete @messengers[mid]
				delete @tree[mid]
				@messengers
			getID : ->
				max = _.max(@messengers , (m) -> m.uid)
				if max
					max.uid + 1
				else
					1


		class Stemcell.Messenger
			constructor : ->
				@views
				@models
				@modelEvents
				@composeBufferHash = {}
				@childrenMessengerID = {}
				args = arguments
				setTimeout () =>
					@initialize.apply @ , args
					, 10
			initialize : ->
			compose : (hash) =>
				for k , v of hash
					@pushChildrenMessenger(k , v)
					v.die = () => @decompose(k)
						# overwrite this die method for child messenger
						#
						# why here?
						# because in child messenger itself, it doesn't know
						# the key in parent messenger which represents it
			decompose : (key) ->
				for k , v of @childrenMessengerID
					if k == key
						if childMessenger = @getChildrenMessenger(k)
							childMessenger.dispose()
						delete @childrenMessengerID[k]
			pushChildrenMessenger : (k , v) =>
				mid = ribosome.pushMessenger(v , @)
				@childrenMessengerID[k] = mid
			getChildrenMessenger : (key) ->
				messengers = []
				if key
					if not (key instanceof Array)
						key = @childrenMessengerID[key]
						return ribosome.getMessenger(key)
				else
					key = _.keys(@childrenMessengerID)
				for k in key
					messengers.push(@childrenMessengerID[k])
				ribosome.getMessenger(messengers)
			getParentMessenger : ->
				ribosome.getParentMessengerByMid @mid
			call : (receiver , signal , options) ->
				receiver.onReceive @ , signal , options
			receivers : {}
			onReceive : (caller , signal , options) ->
				handlerName = ['onReceive', signal[0].toUpperCase(), signal.slice(1)].join('')
				if @[handlerName] instanceof Function
					@handler = @[handlerName]
				else if _.has(@receivers , signal)
					@handler = @receivers[signal]
				else
					log 'received ' + signal + ', no handler, ignored'
					return
				@handler(caller , options)
				@handler = null
			assemble : (args) ->
				if args
					for k , renderArgs of args
						view = @views[k]
						view.render(renderArgs)
				else
					for k , view of @views
						view.render()
				@_extra()
			setViews : (viewMap) ->
				@views = viewMap
				@bindingViewEvents()
			unsetViews : ->
				@views = {}
			getView : (key) ->
				@views[key]
			bindingViewEvents : ->
				for k , view of @views
					_this = @
					view.onFireEvent = (
						(k) ->
							(event , options) -> _this.catchViewEvent(event , k , options)
					)(k)
			catchViewEvent : (event , key , options)->
				handler = @viewEvents[[key , event].join(":")]
				if @[handler]
					view = @views[key]
					@[handler](event , view , options)
				else
					log "caught view events: <" + handler + "> , but no handler in this messenger"
			setModels : (modelMap) ->
				@models = modelMap
				@bindingModelEvents()
			unsetModels : ->
				@models = {}
			getModel : (key) ->
				@models[key]
			bindingModelEvents : ->
				for k , v of @modelEvents
					evtExp = k.split(":")
					model = @getModel(evtExp.shift())
					evt = evtExp.join(":")
					model.on evt , @[v] , @
			unbindModelEvents : ->
				for k , v of @modelEvents
					evtExp = k.split(":")
					model = @getModel(evtExp.shift())
					model.off null , null , @
			die : ->
			dispose : ->
				@onDispose()
				@viewEvents = {}
				@receivers = {}
				@modelEvents = {}
				@unbindModelEvents()
				for k , view of @views
					view.dispose()
				@unsetViews()
				@unsetModels()
				ribosome.removeMessengerByMid(@mid)
			onDispose : ->
			_extra : ->


		class Stemcell.DocumentMessenger extends Stemcell.Messenger
			@instance : null
			@getInstance : ->
				if !@instance
					@instance = new @
				@instance

		class Stemcell.ListMessenger extends Stemcell.Messenger
			initialize : ->
				@_collection = []
			setCollection : (collection) ->
				@_collection = collection
				@bindingCollectionEvents()
			getCollection : =>
				@_collection
			bindingCollectionEvents : ->
				for k , v of @collectionEvents
					@_collection.on k,
						() => @[v](),
						@
			spawn : (index , subMessenger) =>
				obj = {}
				obj[index] = subMessenger
				@compose(obj)
			spawnAll : (messengerClass , models) =>
				for m , i in models
					@spawn i , new messengerClass(m)
			dispose : ->
				@_collection.off null , null , @
				super





		class Stemcell.Model extends Backbone.Model
		
		class Stemcell.Collection extends Backbone.Collection



		Stemcell.log = Stemcell.View.prototype.log = Stemcell.Model.prototype.log = Stemcell.Messenger.prototype.log = Stemcell.Collection.prototype.log = log
		Stemcell.error = Stemcell.View.prototype.error = Stemcell.Model.prototype.error = Stemcell.Messenger.prototype.error = Stemcell.Collection.prototype.error = error
).call(@)
