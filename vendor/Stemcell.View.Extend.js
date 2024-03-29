// Generated by CoffeeScript 1.4.0

Stemcell.View.prototype.errorInfo = function(error, top) {
  var info, infoWrapper;
  info = _.template(userTemplates.infoBar, {
    "info": error
  });
  infoWrapper = this.$el.find("#infoWrapper");
  infoWrapper.empty();
  infoWrapper.append(info);
  return ViewHelper.rollToTop(function() {
    return infoWrapper.fadeIn(1000).delay(3000).fadeOut(1000);
  }, 50, top);
};

Stemcell.View.prototype.expandCountryList = function(countries) {
  this.$el.find("#country_targeting_on").click();
  return _.each(countries.split(","), function(c) {
    var selector;
    selector = "input.country[country_code=" + c + "]";
    return $(selector).each(function() {
      var checkedCount, continent, totalCount, wrapper;
      continent = $(this).parent("li").parents("li").find("input.continent");
      wrapper = $(this).parents("ul.inner");
      $(this).attr("checked", "checked");
      wrapper.css({
        "display": "block"
      });
      totalCount = wrapper.find("input.country").size();
      checkedCount = wrapper.find("input.country[checked='checked']").size();
      if (checkedCount === totalCount) {
        return continent.attr("checked", "checked");
      }
    });
  });
};

Stemcell.View.prototype.submitEnable = function() {
  this._submit = this._submit || this.$el.find("form input[type='submit']:first");
  this._submit.removeAttr("disabled");
  return this._submit.attr({
    "class": this.cachedClass
  });
};

Stemcell.View.prototype.submitDisable = function() {
  this._submit = this._submit || this.$el.find("form input[type='submit']:first");
  if (this._submit) {
    this._submit.css({
      width: this._submit.outerWidth(),
      height: this._submit.outerHeight()
    });
    this.cachedClass = $(this._submit).attr("class");
    return $(this._submit).attr({
      "class": "submitting",
      "disabled": "disabled"
    });
  } else {
    return alert('@_submit object missing, assign a JQuery object to @_submit in your View before using this method');
  }
};
