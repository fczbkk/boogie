describe 'Boogie', ->


  b = null


  beforeEach ->
    b = new Boogie
    b.activate()

    for method in ['log', 'info', 'warn', 'error']
      spyOn console, method
      #  .and.callThrough()


  describe 'meta', ->

    it 'should exist', ->
      expect(Boogie).toBeDefined()


  describe 'options', ->

    it 'should use default options', ->
      expect(b.options).toEqual b.default_options

    it 'should use options provided at init', ->
      b = new Boogie {prefix: 'xxx'}
      expect(b.options.prefix).toEqual 'xxx'

    it 'should mix in options added later', ->
      b.setOptions {prefix: 'yyy'}
      expect(b.options.prefix).toEqual 'yyy'


  describe 'codes', ->

    it 'should have list of codes', ->
      expect(b.options.codes).toBeDefined()

    it 'should have method to set codes', ->
      b.setOptions codes: {aaa: 'bbb', ccc: 'ddd'}
      expect(b.options.codes.aaa).toEqual 'bbb'
      expect(b.options.codes.ccc).toEqual 'ddd'

  describe 'templates', ->

    it 'should allow simple text templates', ->
      expect(b.evalTemplate 'aaa').toEqual 'aaa'

    it 'should evaluate function template', ->
      template = -> 'aaa'
      expect(b.evalTemplate template).toEqual 'aaa'

    it 'should provide data to template when evaluating', ->
      template = (data) -> 'aaa' + data.bbb
      expect(b.evalTemplate template, {bbb: 'ccc'}).toEqual 'aaaccc'


  describe 'log methods', ->

    beforeEach ->
      spyOn b, 'record'

    it 'should have `log()` method', ->
      b.log 'aaa', 'bbb'
      expect(b.record).toHaveBeenCalledWith 'log', 'aaa', 'bbb'

    it 'should have `info()` method', ->
      b.info 'aaa', 'bbb'
      expect(b.record).toHaveBeenCalledWith 'info', 'aaa', 'bbb'

    it 'should have `warn()` method', ->
      b.warn 'aaa', 'bbb'
      expect(b.record).toHaveBeenCalledWith 'warn', 'aaa', 'bbb'

    it 'should have `error()` method', ->
      b.error 'aaa', 'bbb'
      expect(b.record).toHaveBeenCalledWith 'error', 'aaa', 'bbb'


  describe 'history', ->

    it 'should keep track of all items', ->
      expect(b.history).toBeDefined()

    it 'should add item', ->
      b.log()
      expect(b.history.length).toEqual 1

    it 'should store all items', ->
      b.log()
      b.log()
      b.log()
      expect(b.history.length).toEqual 3

    it 'should remember timestamp of an item', ->
      b.log()
      expect(b.history[0].timestamp).toBeDefined()

    it 'should remember type of item', ->
      b.log()
      expect(b.history[0].type).toEqual 'log'

    it 'should remember code of item', ->
      b.log 'aaa'
      expect(b.history[0].code).toEqual 'aaa'

    it 'should remember data of item', ->
      b.log 'aaa', 'bbb'
      expect(b.history[0].data).toEqual 'bbb'


  describe 'console', ->

    it 'should send evaluated message and data to the console', ->
      b.setOptions codes:
        aaa: (data) -> "aaa#{data.bbb}"
      b.log 'aaa', {bbb: 'ccc'}
      expect(console.log).toHaveBeenCalledWith 'aaaccc', {bbb: 'ccc'}

    it 'should map `log()` to `console.log()`', ->
      b.log()
      expect(console.log).toHaveBeenCalled()

    it 'should map `info()` to `console.info()`', ->
      b.info()
      expect(console.info).toHaveBeenCalled()

    it 'should map `warn()` to `console.warn()`', ->
      b.warn()
      expect(console.warn).toHaveBeenCalled()

    it 'should map `error()` to `console.error()`', ->
      b.error()
      expect(console.error).toHaveBeenCalled()


  describe 'prefix', ->

    it 'should allow to set prefix via options', ->
      b.setOptions {prefix: 'aaa'}
      expect(b.options.prefix).toEqual 'aaa'

    it 'should include prefix in the console output', ->
      b.setOptions
        prefix: 'aaa'
        codes: {bbb: 'ccc'}
      b.log 'bbb'
      args = console.log.calls.mostRecent().args
      expect(args[0]).toEqual 'aaa'
      expect(args[1]).toEqual 'ccc'


  describe 'onRecord', ->

    it 'should allow to set callback via options', ->
      fn = ->
      b.setOptions {onRecord: fn}
      expect(b.options.onRecord).toEqual fn

    it 'should call callback when item is added', ->
      spyOn b.options, 'onRecord'
      b.log()
      expect(b.options.onRecord).toHaveBeenCalled()

    it 'should provide type in the callback', ->
      spyOn b.options, 'onRecord'
      b.log()
      args = b.options.onRecord.calls.mostRecent().args
      expect(args[0]).toEqual 'log'

    it 'should provide code in the callback', ->
      spyOn b.options, 'onRecord'
      b.setOptions codes: {bbb: 'ccc'}
      b.log 'bbb'
      args = b.options.onRecord.calls.mostRecent().args
      expect(args[1]).toEqual 'bbb'

    it 'should provide data in the callback', ->
      spyOn b.options, 'onRecord'
      data = {aaa: 'bbb'}
      b.log 'bbb', data
      args = b.options.onRecord.calls.mostRecent().args
      expect(args[2]).toEqual data

    it 'should provide message in the callback', ->
      spyOn b.options, 'onRecord'
      b.setOptions codes: {bbb: 'ccc'}
      b.log 'bbb'
      args = b.options.onRecord.calls.mostRecent().args
      expect(args[3]).toEqual 'ccc'


  describe 'onActivate', ->

    it 'should be called when activated', ->
      spyOn b.options, 'onActivate'
      b.activate()
      expect(b.options.onActivate).toHaveBeenCalled()


  describe 'onDeactivate', ->

    it 'should be called when deactivated', ->
      spyOn b.options, 'onDeactivate'
      b.deactivate()
      expect(b.options.onDeactivate).toHaveBeenCalled()


  describe 'filter', ->

    it 'should be set by default', ->
      expect(b.options.filter).toEqual ['log', 'info', 'warn', 'error']

    it 'should be able to set the filter via options', ->
      b.setOptions {filter: ['aaa']}
      expect(b.options.filter).toEqual ['aaa']

    it 'should not send filtered items to console', ->
      b.setOptions filter: ['log']
      b.log()
      b.info()
      expect(console.log).toHaveBeenCalled()
      expect(console.info).not.toHaveBeenCalled()

    it 'should not call callback for filtered items', ->
      spyOn b.options, 'onRecord'
      b.setOptions filter: []
      b.log()
      expect(b.options.onRecord).not.toHaveBeenCalled()


  describe 'state', ->

    it 'should be inactive by default', ->
      b = new Boogie
      expect(b.is_active).toEqual false

    it 'should be possible to activate', ->
      b.activate()
      expect(b.is_active).toEqual true

    it 'should be possible deactivate', ->
      b.activate()
      b.deactivate()
      expect(b.is_active).toEqual false

    it 'should not record any data when inactive', ->
      b.deactivate()
      b.log()
      expect(b.history.length).toEqual 0


  describe 'control by URL', ->

    it 'should have option for url prefix', ->
      expect(b.options.url_prefix).toEqual 'boogie'

    it 'should parse URL params from document location', ->
      result = b.parseLocation {search: '?aaa=bbb&ccc=ddd'}
      expect(result).toEqual {aaa: 'bbb', ccc: 'ddd'}

    it 'should activate via URL param', ->
      b.deactivate()
      result = b.evalLocation {search: '?boogieactivate=1'}
      expect(b.is_active).toEqual true

    it 'should set filter via URL param', ->
      result = b.evalLocation {search: '?boogiefilter=info,warn'}
      expect(b.options.filter).toEqual ['info', 'warn']

    it 'should use url_prefix when parsing location', ->
      b.deactivate()
      b.setOptions {url_prefix: 'aaa'}

      b.evalLocation {search: '?boogieactivate=1'}
      expect(b.is_active).toEqual false

      b.evalLocation {search: '?aaaactivate=1'}
      expect(b.is_active).toEqual true

    it 'should check for URL params upon init', ->
      spyOn Boogie.prototype, 'evalLocation'
      b = new Boogie
      expect(Boogie::evalLocation).toHaveBeenCalled()
