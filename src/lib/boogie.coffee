noop = ->


class Boogie


  default_options:
    filter: ['log', 'info', 'warn', 'error']
    codes: {}
    prefix: null
    url_prefix: 'boogie'
    unknown_template: 'Unkonwn event.'
    onRecord: noop
    onActivate: noop
    onDeactivate: noop


  constructor: (options) ->
    @is_active = false
    @options = {}
    @setOptions @default_options
    @setOptions options
    @history = []
    @evalLocation()


  setOptions: (options = {}) ->
    for key, val of options
      @options[key] = val


  getTemplateByCode: (code) ->
    return @options.unknown_template unless code

    template_object = @options.codes
    for step in code.split '.'
      template_object = template_object[step]

    return template_object


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

    template = @getTemplateByCode code

    item =
      type: type
      code: code
      data: data
      timestamp: (new Date).getTime()
      message: @evalTemplate template, data

    @history.push item

    if type in @options.filter

      console_args = [item.message, data]
      console_args.unshift @options.prefix if @options.prefix?
      console[type].apply console, console_args

      @options.onRecord type, code, data, item.message


  log:   (code, data) -> @record 'log',   code, data
  info:  (code, data) -> @record 'info',  code, data
  warn:  (code, data) -> @record 'warn',  code, data
  error: (code, data) -> @record 'error', code, data


  activate: ->
    @is_active = true
    @options.onActivate()


  deactivate: ->
    @is_active = false
    @options.onDeactivate()


  parseLocation: (location) ->
    result = {}

    location.search
      ?.replace /^\?/, ''
      .split '&'
      .map (item) ->
        [key, val] = item.split '='
        result[key] = val

    result


  evalLocation: (location = document.location) ->
    params = @parseLocation location

    if params["#{@options.url_prefix}activate"]?
      @activate()

    if params["#{@options.url_prefix}filter"]?
      @setOptions filter: params["#{@options.url_prefix}filter"].split ','


# Expose object to the global namespace.
if expose?
  expose Boogie, 'Boogie'
else
  root = if typeof exports is 'object' then exports else this
  root.Boogie = Boogie
