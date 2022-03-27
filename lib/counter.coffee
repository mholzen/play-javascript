EventEmitter = require 'events'

class Counter
  constructor: (max)->
    @max = max
    @value = 0
  inc: ->
    @value++
    if @max?
      @value = @value % @max

module.exports = {Counter}
