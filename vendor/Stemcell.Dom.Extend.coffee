	Stemcell.Dom =
		toggleCheckBox : (targetObj)->
			targetObj = $(targetObj);
			checkboxObj = $("#"+targetObj.attr("forid"));
			if(targetObj.hasClass("checked"))
				targetObj.removeClass("checked");
				checkboxObj.removeAttr("checked");
			else
				targetObj.addClass("checked");
				checkboxObj.attr("checked" , "");
		form2Obj : (form) ->
			@formArray2Obj $(form).serializeArray()
		formArray2Obj : (formArray)->
			obj = {}
			for form in formArray
				key = form["name"]
				val = form["value"]
				if(obj[key])
					ele = obj[key]
					if(ele instanceof Array)
						obj[key].push(val)
					else
						obj[key] = [ele , val]
				else
					obj[key] = val
			return obj

		rollToTop : (fn , duration , toScrollTop)->
			duration = duration or 50
			toScrollTop = toScrollTop or 0
			st = $(document).scrollTop()
			step = (st - toScrollTop) / duration
			interval = setInterval(
				()->
					if(st > toScrollTop)
					    st = st - step
					    $(document).scrollTop(st)
					else
						$(document).scrollTop(toScrollTop)
						if(fn instanceof Function)
							fn()
						clearInterval(interval)
			,1)

		rollToBottom : (fn , duration , toScrollTop)->
			duration = duration or 50
			toScrollTop = toScrollTop or 0
			st = $(document).scrollTop()
			step = (st - toScrollTop) / duration
			interval = setInterval(
				()->
					if(st > toScrollTop)
					    st = st - step
					    $(document).scrollTop(st)
					else
						$(document).scrollTop(toScrollTop)
						if(fn instanceof Function)
							fn()
						clearInterval(interval)
			,1)

		inputOnFocus : (target)->
		    target = $(target);
		    target.addClass('focusedInput');

		inputOnBlur : (target)->
		    target = $(target);
		    target.removeClass('focusedInput');
		getCookie : (name)->
			r = document.cookie.match("\\b" + name + "=([^;]*)\\b")
			r = if r then r[1] else undefined
			r
		delCookie : (name)->
			date = new Date()
			date.setTime(date.getTime() - 1000000)
			document.cookie = name + "=a; expires=" + date.toGMTString()
			document.cookie = name + "=a; expires=" + date.toGMTString()
		cover : (obj) ->
			obj = $(obj)
			width = obj.outerWidth()
			height = obj.outerHeight()
			obj.css({'position' : 'relative'})
			obj.append('<div class="cover"></div>')
			obj.find(".cover").css({
					width : width , 
					height : height , 
					"opacity" : 0.8
			})
		uncover : (obj) ->
			obj = $(obj)
			obj.find(".cover").remove()
		log : (obj) ->
			false
			#console.log obj
