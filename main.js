// Generated by CoffeeScript 1.4.0

/*global requirejs,define
*/


(function() {

  requirejs.config({
    paths: {
      backbone: 'lib/backbone',
      underscore: 'lib/underscore',
      $: 'lib/jquery-1.8.2.min',
      stemcell: 'lib/stemcell',
      appConfig: 'config/AppConfig',
      appRouter: 'config/router'
    },
    shim: {
      $: {
        exports: '$'
      },
      backbone: {
        deps: ['$', 'underscore'],
        exports: 'Backbone'
      },
      stemcell: {
        deps: ['$', 'backbone'],
        exports: 'Stemcell'
      },
      appConfig: {
        deps: ['stemcell'],
        exports: 'AppConfig'
      }
    }
  });

  requirejs(['$', 'underscore', 'backbone', 'stemcell'], function() {
    return require(['appConfig'], function() {
      var exts, k, v, _ref;
      exts = [];
      _ref = AppConfig.Stemcell;
      for (k in _ref) {
        v = _ref[k];
        exts.push(v);
      }
      return require(exts, function() {
        return require(['appRouter'], function() {});
      });
    });
  });

}).call(this);
