/*
Boogie, v0.2.1
by Riki Fridrich <riki@fczbkk.com> (https://github.com/fczbkk)
https://github.com/fczbkk/boogie
*/

(function() {
  var Boogie, root,
    indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Boogie = (function() {
    Boogie.prototype.default_options = {
      filter: ['log', 'info', 'warn', 'error'],
      codes: {},
      prefix: null,
      url_prefix: 'boogie',
      unknown_template: 'Unkonwn event.',
      callback: function() {}
    };

    function Boogie(options) {
      this.is_active = false;
      this.options = {};
      this.setOptions(this.default_options);
      this.setOptions(options);
      this.history = [];
      this.evalLocation();
    }

    Boogie.prototype.setOptions = function(options) {
      var key, results, val;
      if (options == null) {
        options = {};
      }
      results = [];
      for (key in options) {
        val = options[key];
        results.push(this.options[key] = val);
      }
      return results;
    };

    Boogie.prototype.setCallback = function(fn) {
      if (fn == null) {
        fn = function() {};
      }
      return this.setOptions({
        callback: fn
      });
    };

    Boogie.prototype.setPrefix = function(val) {
      return this.setOptions({
        prefix: val
      });
    };

    Boogie.prototype.setCodes = function(codes) {
      var key, results, val;
      if (codes == null) {
        codes = {};
      }
      results = [];
      for (key in codes) {
        val = codes[key];
        results.push(this.options.codes[key] = val);
      }
      return results;
    };

    Boogie.prototype.setFilter = function(items) {
      if (items == null) {
        items = [];
      }
      return this.setOptions({
        filter: items
      });
    };

    Boogie.prototype.resetFilter = function() {
      return this.setFilter(['log', 'info', 'warn', 'error']);
    };

    Boogie.prototype.evalTemplate = function(template, data) {
      if (template == null) {
        template = this.options.unknown_template;
      }
      if (data == null) {
        data = {};
      }
      switch (typeof template) {
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

    Boogie.prototype.record = function(type, code, data) {
      var console_args, item;
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
      item = {
        type: type,
        code: code,
        data: data,
        timestamp: (new Date).getTime(),
        message: this.evalTemplate(this.options.codes[code], data)
      };
      this.history.push(item);
      if (indexOf.call(this.options.filter, type) >= 0) {
        console_args = [item.message, data];
        if (this.options.prefix != null) {
          console_args.unshift(this.options.prefix);
        }
        console[type].apply(console, console_args);
        return this.options.callback(type, code, data, item.message);
      }
    };

    Boogie.prototype.log = function(code, data) {
      return this.record('log', code, data);
    };

    Boogie.prototype.info = function(code, data) {
      return this.record('info', code, data);
    };

    Boogie.prototype.warn = function(code, data) {
      return this.record('warn', code, data);
    };

    Boogie.prototype.error = function(code, data) {
      return this.record('error', code, data);
    };

    Boogie.prototype.activate = function() {
      return this.is_active = true;
    };

    Boogie.prototype.deactivate = function() {
      return this.is_active = false;
    };

    Boogie.prototype.parseLocation = function(location) {
      var ref, result;
      result = {};
      if ((ref = location.search) != null) {
        ref.replace(/^\?/, '').split('&').map(function(item) {
          var key, ref1, val;
          ref1 = item.split('='), key = ref1[0], val = ref1[1];
          return result[key] = val;
        });
      }
      return result;
    };

    Boogie.prototype.evalLocation = function(location) {
      var params;
      if (location == null) {
        location = document.location;
      }
      params = this.parseLocation(location);
      if (params[this.options.url_prefix + "activate"] != null) {
        this.activate();
      }
      if (params[this.options.url_prefix + "filter"] != null) {
        return this.setFilter(params[this.options.url_prefix + "filter"].split(','));
      }
    };

    return Boogie;

  })();

  if (typeof expose !== "undefined" && expose !== null) {
    expose(Boogie, 'Boogie');
  } else {
    root = typeof exports === 'object' ? exports : this;
    root.Boogie = Boogie;
  }

}).call(this);
