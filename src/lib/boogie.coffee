class Boogie

  constructor: ->

# Expose object to the global namespace.
root = if typeof exports is 'object' then exports else this
root.Boogie = Boogie
