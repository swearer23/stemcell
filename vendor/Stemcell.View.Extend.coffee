Stemcell.View.prototype.errorInfo = (error , top) ->
	info = _.template(userTemplates.infoBar , {"info" : error})
	infoWrapper = @$el.find("#infoWrapper")
	infoWrapper.empty()
	infoWrapper.append(info)
	ViewHelper.rollToTop(
		() ->
			infoWrapper.fadeIn(1000).delay(3000).fadeOut(1000) 
		, 50 , top
	)

Stemcell.View.prototype.expandCountryList = (countries) ->
	@$el.find("#country_targeting_on").click()
	_.each(countries.split(",") , (c) ->
		selector = ("input.country[country_code="+c+"]")
		$(selector).each(() ->
			continent = $(@).parent("li").parents("li").find("input.continent")
			wrapper = $(@).parents("ul.inner")
			$(@).attr("checked" , "checked")
			wrapper.css({"display" : "block"})
			totalCount = wrapper.find("input.country").size()
			checkedCount = wrapper.find("input.country[checked='checked']").size()
			if checkedCount == totalCount
				continent.attr("checked" , "checked")
		)
	)

Stemcell.View.prototype.submitEnable = () ->
	@_submit = @_submit or @$el.find("form input[type='submit']:first")
	@_submit.removeAttr("disabled")
	@_submit.attr({"class"  : @cachedClass})
  
Stemcell.View.prototype.submitDisable = () ->
	@_submit = @_submit or @$el.find("form input[type='submit']:first")
	if @_submit
		@_submit.css({
			width:@_submit.outerWidth(),
			height:@_submit.outerHeight()
		})
		@cachedClass = $(@_submit).attr("class")
		$(@_submit).attr({
			"class"     : "submitting",
			"disabled"  : "disabled"
		})
	else
		alert '@_submit object missing, assign a JQuery object to @_submit in your View before using this method'
