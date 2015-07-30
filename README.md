# ![Boogie](assets/logo.png)

Debugging and logging utility for JavaScript.

I have created this to help me with debugging of various JS libraries implemented by clients. It allows me to prepare useful debugging messages and data in the code. They will be inactive, they won't pollute the console or anything. But when I need them, I have a simple way to activate them.

## How to use

First, create an instance of `Boogie` object and set the options. The defaults should be fine in most cases, but you will probably want to set a list of messages you will use:

```javascript
var my_boogie = new Boogie({
  init_ok: 'Object was initialized properly.',
  init_fail: 'Object initialization failed.',
  missing_param: function (data) {
    return "Method '" + data.method_name + "' is missing param `" + data.param_name + "`."
  }
});
```

Then add debug messages to your code:

```javascript
var MyObject = {

  init: function () {
    ...
    if (everything_is_ok === true) {
      my_boogie.info('init_ok');
    } else {
      my_boogie.error('init_fail');
    }
  }

  someMethod: function (aaa) {
    if (!aaa) {
      my_boogie.warn('missing_param', {
        method_name: 'someMethod',
        param_name: 'aaa'
      });
    }
    ...
  }

}
```

This will not do anything, unless your instance of Boogie is activated. There will be logs in the `console`, no callbacks, nothing. When you need to debug the code, you can activate your instance of Boogie in two ways:

You can activate it directly from console:

```javascript
my_boogie.activate()
```

Or you can activate it using GET parameter in the URL. This is handy in situations when you are trying to debug the code that is executed before page load:

```
...?boogieactivate=1
```

## Methods

### setOptions()

Use this method to set the options. You can set any number of options at once. Previously set options are not removed, they can only be rewritten by new ones. Example:

```javascript
my_boogie.setOptions({
  aaa: 'bbb',
  ccc: 'ddd'
});

my_boogie.options.aaa;  // -> 'bbb'
my_boogie.options.ccc;  // -> 'ddd'
my_boogie.options.eee;  // -> undefined

my_boogie.setOptions({
  aaa: 'zzz',
  eee: 'fff'
});

my_boogie.options.aaa;  // -> 'zzz' (changed)
my_boogie.options.ccc;  // -> 'ddd' (unchanged)
my_boogie.options.eee;  // -> 'fff'

```

### activate(), deactivate()

Boogie will only evaluate and output anything when in active state. You can use these methods to set the state. All new Boogie instances are inactive.

Example:

```javascript
var my_boogie = new Boogie();

my_boogie.log();  // nothing happens

my_boogie.activate();
my_boogie.log();  // record is evaluated

my_boogie.deactivate();
my_boogie.log();  // nothing happens again

```

### log(), info(), warn(), error()

These methods correspond with `console` methods. They expect two parameters:

- code - `unknown_template` will be used if code is not provided or if template for the code does not exist
- data - `null` by default

## Options

### filter

default `['log', 'info', 'warn', 'error']`

Only records of this type will be evaluated. All other types will be ignored.

### codes

default `{}` (empty object)

List of codes and associated templates. Templates can be of two types:

- `string` - Will be used as-is.
- `function` - Will be evaluated, using provided data as an argument.

Example

```javascript
my_boogie.setOptions({
  codes: {
    simple_message: 'This is simple message.',
    complex_message: function (data) {
      return "Something happened in file '" + data.file + "' at line " + data.line + ".";
    }
  }
});

my_boogie.log('simple_message');
// -> This is simple message.

my_boogie.log('complex_message', {file: 'my_file.html', line: 100});
// -> Something happened in file 'my_file.html' at line 100.
```

### unknown_template

default `'Unkonwn event.'`

This template will be used when there is no template for used code. Example:

```javascript
my_boogie.setOptions({codes: {aaa: 'aaa'}});

my_boogie.log('aaa');  // -> 'aaa'
my_boogie.log('zzz');  // -> 'Unknown event.'
```

### prefix

default `null`

If set, it will prepend the value to all messages sent to `console`. Example:

```javascript
my_boogie.setOptions({prefix: 'aaa'});
my_boogie.log('bbb');  // -> 'aaa bbb'

my_boogie.setOptions({prefix: null});
my_boogie.log('bbb');  // -> 'bbb'
```

### url_prefix

default `'boogie'`

When checking for URL parameters used to activate or set filter, the parameters need to be prefixed with this value. It is intended to be used to prevent naming conflicts. Example

```javascript
my_boogie.setOptions({url_prefix: 'aaa'});

// this will do nothing
// ?boogieactivate=1

// this will activate Boogie
// ?aaaactivate=1
```

### onRecord

default `function () {}` (empty function)

This callback will be called every time the `record()` is called with these parameters:

- `type` - log, info, warn, error
- `code` - code of the message
- `data` - provided data
- `message` - evaluated message template for this record

### onActivate

default `function () {}` (empty function)

This callback will be called when Boogie is activated.

### onDeactivate

default `function () {}` (empty function)

This callback will be called when Boogie is deactivated.

## Bug reports, feature requests and contact

If you found any bugs, if you have feature requests or any questions, please, either [file an issue at GitHub](https://github.com/fczbkk/boogie/issues) or send me an e-mail at [riki@fczbkk.com](mailto:riki@fczbkk.com).

## License

Boogie is published under the [MIT license](https://github.com/fczbkk/boogie/blob/master/LICENSE).
