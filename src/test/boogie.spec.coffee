describe 'Boogie', ->


  b = null


  beforeEach ->
    b = new Boogie

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
      b.setCodes {aaa: 'bbb', ccc: 'ddd'}
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
      b.setCodes
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

    it 'should allow to set prefix directly', ->
      b.setPrefix 'aaa'
      expect(b.options.prefix).toEqual 'aaa'

    it 'should include prefix in the console output', ->
      b.setCodes {bbb: 'ccc'}
      b.setPrefix 'aaa'
      b.log 'bbb'
      args = console.log.calls.mostRecent().args
      expect(args[0]).toEqual 'aaa'
      expect(args[1]).toEqual 'ccc'


  describe 'callback', ->

    it 'should allow to set callback via options', ->
      fn = ->
      b.setOptions {callback: fn}
      expect(b.options.callback).toEqual fn

    it 'should allow to set callback directly', ->
      fn = ->
      b.setCallback fn
      expect(b.options.callback).toEqual fn

    it 'should call callback when item is added', ->
      spyOn b.options, 'callback'
      b.log()
      expect(b.options.callback).toHaveBeenCalled()

    it 'should provide type in the callback', ->
      spyOn b.options, 'callback'
      b.log()
      args = b.options.callback.calls.mostRecent().args
      expect(args[0]).toEqual 'log'

    it 'should provide code in the callback', ->
      spyOn b.options, 'callback'
      b.setCodes {bbb: 'ccc'}
      b.log 'bbb'
      args = b.options.callback.calls.mostRecent().args
      expect(args[1]).toEqual 'bbb'

    it 'should provide data in the callback', ->
      spyOn b.options, 'callback'
      data = {aaa: 'bbb'}
      b.log 'bbb', data
      args = b.options.callback.calls.mostRecent().args
      expect(args[2]).toEqual data

    it 'should provide message in the callback', ->
      spyOn b.options, 'callback'
      b.setCodes {bbb: 'ccc'}
      b.log 'bbb'
      args = b.options.callback.calls.mostRecent().args
      expect(args[3]).toEqual 'ccc'



  describe 'filter', ->

    it 'should be set by default', ->
      expect(b.options.filter).toEqual ['log', 'info', 'warn', 'error']

    it 'should be able to set the filter via options', ->
      b.setOptions {filter: ['aaa']}
      expect(b.options.filter).toEqual ['aaa']

    it 'should be able to set the filter directly', ->
      b.setFilter ['aaa']
      expect(b.options.filter).toEqual ['aaa']

    it 'should be able to reset filter', ->
      b.setFilter []
      b.resetFilter()
      expect(b.options.filter).toEqual ['log', 'info', 'warn', 'error']

    it 'should not send filtered items to console', ->
      b.setFilter ['log']
      b.log()
      b.info()
      expect(console.log).toHaveBeenCalled()
      expect(console.info).not.toHaveBeenCalled()

    it 'should not call callback for filtered items', ->
      spyOn b.options, 'callback'
      b.setFilter []
      b.log()
      expect(b.options.callback).not.toHaveBeenCalled()
