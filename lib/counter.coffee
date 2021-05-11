EventEmitter = require 'events'

class Counter
  constructor: (max)->
    @max = max
    @value = -1   # to start on 0
  inc: ->
    @value++
    if @max?
      @value = @value % @max

module.exports = {Counter}
