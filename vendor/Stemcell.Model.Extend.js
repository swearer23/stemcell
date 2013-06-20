// Generated by CoffeeScript 1.4.0

Stemcell.Model.prototype.baseFetch = function(options) {
  var model, success;
  options = _.clone(options) || {};
  model = this;
  success = options.success;
  options.success = function(resp, status, xhr) {
    if (success) {
      return success(model, resp, options);
    }
  };
  return this.sync('read', this, options);
};

Stemcell.Model.prototype.baseSave = function(key, val, options) {
  var attrs, current, done, method, model, silentOptions, success, waitOption, xhr;
  done = false;
  if (key === null || _.isObject(key)) {
    attrs = key;
    options = val;
  } else if (key !== null) {
    (attrs = {})[key] = val;
  }
  options = _.clone(options) || {};
  if (options.wait) {
    if (!this._validate(attrs, options)) {
      return false;
    }
  }
  current = _.clone(this.attributes);
  silentOptions = _.extend({}, options, {
    silent: true
  });
  if (options.wait) {
    waitOption = silentOptions;
  } else {
    waitOption = options;
  }
  if (attrs && !this.set(attrs, waitOption)) {
    return false;
  }
  if (!attrs && !this._validate(null, options)) {
    return false;
  }
  model = this;
  success = options.success;
  options.success = function(resp, status, xhr) {
    var serverAttrs;
    done = true;
    serverAttrs = model.parse(resp, xhr);
    if (options.wait) {
      serverAttrs = _.extend(attrs || {}, serverAttrs);
    }
    if (success) {
      return success(model, resp, options);
    }
  };
  if (this.isNew()) {
    method = 'create';
  } else {
    method = 'update';
  }
  xhr = this.sync(method, this, options);
  if (!done && options.wait) {
    this.clear(silentOptions);
    this.set(current, silentOptions);
  }
  return xhr;
};

Stemcell.Collection.prototype.baseFetch = function(options) {
  var collection, success;
  if (options) {
    options = _.clone(options);
  } else {
    options = {};
  }
  if (options.parse === 0) {
    options.parse = true;
  }
  collection = this;
  success = options.success;
  options.success = function(resp, status, xhr) {
    if (success) {
      return success(collection, resp, options);
    }
  };
  return this.sync('read', this, options);
};
