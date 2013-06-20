define [], () ->
	router = {}
	this.router = window.router = new AppRouter()
	Stemcell.history.start()
	Stemcell.setEmulateJSON(true)

	class AppRouter extends Stemcell.Router
		initialize : () ->
			@setMessengers {}
		routes :
			'' : ''
