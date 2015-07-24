class Boogie


  default_options:
    filter: ['log', 'info', 'warn', 'error']
    codes: {}
    prefix: null
    unknown_template: 'Unkonwn event.'
    callback: ->


  constructor: (options) ->
    @is_active = false
    @options = {}
    @setOptions @default_options
    @setOptions options
    @history = []


  setOptions: (options = {}) ->
    for key, val of options
      @options[key] = val


  setCallback: (fn = ->) ->
    @setOptions {callback: fn}


  setPrefix: (val) ->
    @setOptions {prefix: val}


  setCodes: (codes = {}) ->
    for key, val of codes
      @options.codes[key] = val


  setFilter: (items = []) ->
    @setOptions {filter: items}


  resetFilter: ->
    @setFilter ['log', 'info', 'warn', 'error']


  evalTemplate: (template = @options.unknown_template, data = {}) ->
    switch typeof template
      when 'function'
        template data
      when 'string'
        template
      else
        if template.toString?
          template.toString()
        else
          template


  record: (type = 'log', code = null, data = {}) ->
    return unless @is_active

    item =
      type: type
      code: code
      data: data
      timestamp: (new Date).getTime()
      message: @evalTemplate @options.codes[code], data

    @history.push item

    if type in @options.filter

      console_args = [item.message, data]
      console_args.unshift @options.prefix if @options.prefix?
      console[type].apply console, console_args

      @options.callback type, code, data, item.message


  log:   (code, data) -> @record 'log',   code, data
  info:  (code, data) -> @record 'info',  code, data
  warn:  (code, data) -> @record 'warn',  code, data
  error: (code, data) -> @record 'error', code, data


  activate: -> @is_active = true
  deactivate: -> @is_active = false


# Expose object to the global namespace.
root = if typeof exports is 'object' then exports else this
root.Boogie = Boogie
