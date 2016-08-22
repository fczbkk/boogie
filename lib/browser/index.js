(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["Boogie"] = factory();
	else
		root["Boogie"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports) {

	'use strict';

	var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol ? "symbol" : typeof obj; };

	var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

	var Boogie,
	    default_options,
	    noop,
	    indexOf = [].indexOf || function (item) {
	  for (var i = 0, l = this.length; i < l; i++) {
	    if (i in this && this[i] === item) return i;
	  }return -1;
	};

	noop = function noop() {};

	default_options = {
	  filter: ['log', 'info', 'warn', 'error'],
	  codes: {},
	  prefix: null,
	  url_prefix: 'boogie',
	  unknown_template: 'Unkonwn event.',
	  onRecord: noop,
	  onActivate: noop,
	  onDeactivate: noop
	};

	module.exports = Boogie = function () {
	  function Boogie(options) {
	    this.is_active = false;
	    this.options = {};
	    this.setOptions(default_options);
	    this.setOptions(options);
	    this.history = [];
	    this.evalLocation();
	    this.evalStorage();
	  }

	  Boogie.prototype.setOptions = function (options) {
	    if (options == null) {
	      options = {};
	    }
	    return this.options = _extends(this.options, options);
	  };

	  Boogie.prototype.getTemplateByCode = function (code) {
	    var found_object, i, len, ref, step;
	    if (!code) {
	      return this.options.unknown_template;
	    }
	    found_object = this.options.codes;
	    ref = code.split('.');
	    for (i = 0, len = ref.length; i < len; i++) {
	      step = ref[i];
	      if (found_object[step] == null) {
	        return this.options.unknown_template;
	      }
	      found_object = found_object[step];
	    }
	    return found_object;
	  };

	  Boogie.prototype.evalTemplate = function (template, data) {
	    if (template == null) {
	      template = this.options.unknown_template;
	    }
	    if (data == null) {
	      data = {};
	    }
	    switch (typeof template === 'undefined' ? 'undefined' : _typeof(template)) {
	      case 'function':
	        return template(data);
	      case 'string':
	        return template;
	      default:
	        if (template.toString != null) {
	          return template.toString();
	        } else {
	          return template;
	        }
	    }
	  };

	  Boogie.prototype.record = function (type, code, data) {
	    var console_args, item, template;
	    if (type == null) {
	      type = 'log';
	    }
	    if (code == null) {
	      code = null;
	    }
	    if (data == null) {
	      data = {};
	    }
	    if (!this.is_active) {
	      return;
	    }
	    template = this.getTemplateByCode(code);
	    item = {
	      type: type,
	      code: code,
	      data: data,
	      timestamp: new Date().getTime(),
	      message: this.evalTemplate(template, data)
	    };
	    this.history.push(item);
	    if (indexOf.call(this.options.filter, type) >= 0) {
	      console_args = [item.message, data];
	      if (this.options.prefix != null) {
	        console_args.unshift(this.options.prefix);
	      }
	      console[type].apply(console, console_args);
	      return this.options.onRecord(type, code, data, item.message);
	    }
	  };

	  Boogie.prototype.log = function (code, data) {
	    return this.record('log', code, data);
	  };

	  Boogie.prototype.info = function (code, data) {
	    return this.record('info', code, data);
	  };

	  Boogie.prototype.warn = function (code, data) {
	    return this.record('warn', code, data);
	  };

	  Boogie.prototype.error = function (code, data) {
	    return this.record('error', code, data);
	  };

	  Boogie.prototype.activate = function () {
	    this.is_active = true;
	    return this.options.onActivate();
	  };

	  Boogie.prototype.deactivate = function () {
	    this.is_active = false;
	    return this.options.onDeactivate();
	  };

	  Boogie.prototype.parseLocation = function (location) {
	    var ref, result;
	    result = {};
	    if ((ref = location.search) != null) {
	      ref.replace(/^\?/, '').split('&').map(function (item) {
	        var key, ref1, val;
	        ref1 = item.split('='), key = ref1[0], val = ref1[1];
	        return result[key] = val;
	      });
	    }
	    return result;
	  };

	  Boogie.prototype.evalLocation = function (location) {
	    var found_filter, params;
	    if (location == null) {
	      location = document.location;
	    }
	    params = this.parseLocation(location);
	    if (params[this.options.url_prefix + "activate"] != null) {
	      this.activate();
	    }
	    found_filter = params[this.options.url_prefix + "filter"];
	    if (found_filter != null) {
	      return this.setOptions({
	        filter: found_filter.split(',')
	      });
	    }
	  };

	  Boogie.prototype.evalStorage = function () {
	    var found_filter;
	    if (localStorage.getItem(this.options.url_prefix + "activate") != null) {
	      this.activate();
	    }
	    found_filter = localStorage.getItem(this.options.url_prefix + "filter");
	    if (found_filter != null) {
	      return this.setOptions({
	        filter: found_filter.split(',')
	      });
	    }
	  };

	  return Boogie;
	}();

/***/ }
/******/ ])
});
;