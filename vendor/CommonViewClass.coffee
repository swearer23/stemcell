define [], () ->
	CommonFormView :
		class CommonFormView extends Stemcell.View
			initialize : (model) ->
				@model = model
				@getModel()
			submitHandler : =>
				@submitDisable()
				@model.off "change"
				@model.on "change" , () =>
					@render()
					@updateSuccessHandler()
				@model.onError  = () => @errorInfo(@model.error)
				obj = ViewHelper.formArray2Obj @form.serializeArray()
				@updateModel obj
				false
			render : =>
				@template = _.template @tpl , {obj : @model.toJSON()}
				@$el.html @template
				@form = @$el.find "form"
				@form.submit @submitHandler
			getModel : ->
