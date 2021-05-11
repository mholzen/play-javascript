EventEmitter = require 'events'
{Counter} = require './counter'

# TDOO: test
class Clock extends EventEmitter
  constructor: (bpm = 120, ticks = 24, beats = 4, bars = 4)->
    super()
    @bpm = bpm

    @ticks = ticks
    @counter = new Counter ticks * beats * bars

    @beats = beats
    @beat = 0

    @bars = bars
    @bar = 0

    @intervalMillis = ( 60.0 / @bpm ) / @ticks * 1000.0
    @interval = setInterval (=> @tick()), @intervalMillis
  
  reset:->
    clearInterval @interval
    @counter.value = -1
    @beat = 0
    @bar = 0
    @intervalMillis = ( 60.0 / @bpm ) / @ticks * 1000.0
    @interval = setInterval (=> @tick()), @intervalMillis

  tick: ->
    @counter.inc()
    @emit 'tick', @
    if (@counter.value % @ticks) == 0
      @beat = Math.floor ( @counter.value / @ticks ) % @bars
      @emit 'beat', @
      @emit 'beat:'+@beat, @

    if (@counter.value % (@ticks*@beats) ) == 0
      @bar = Math.floor ( @counter.value / (@ticks*@beats) )
      @emit 'bar', @
      @emit 'bar:'+@bar, @

module.exports = {Clock}
