EventEmitter = require 'events'
{Counter} = require './counter'

# TDOO: test
class Clock extends EventEmitter
  constructor: (bpm = 120, ticks = 24, beats = 4, bars = 4)->
    super()
    @bpm = bpm

    @ticks = ticks
    @counter = new Counter() # ticks * beats * bars

    @beats = beats
    @beat = 0

    @bars = bars
    @bar = 0
    @pos = 0

    @start = process.hrtime.bigint()
    @intervalMillis = ( 60.0 / @bpm ) / @ticks * 1000.0
    @beatMs = @intervalMillis * 24
    @barMs = @beatMs * 4
    # @interval = setInterval (=> @tick()), @intervalMillis
    @scheduleNext()

  scheduleNext: ->
    now = process.hrtime.bigint()
    next = @start + (BigInt(@counter.value) + 1n) * BigInt( (@intervalMillis * 1000 * 1000).toFixed(0) )
    # console.log 'inc', @counter.value, (BigInt(@counter.value) + 1n)
    # counter starts at -1
    nextInterval = next - now
    if nextInterval < 0
      # console.log @start, now, now - @start, BigInt( (@intervalMillis * 1000 * 1000).toFixed(0) )
      nextInterval = 0n
    nextIntervalMs = Number nextInterval / 1000n / 1000n 
    # console.log now, next, nextInterval, nextIntervalMs
    setTimeout (=>@tick()), nextIntervalMs

  reset:->
    clearInterval @interval
    @counter.value = 0
    @beat = 0
    @bar = 0
    @pos = 0
    @start = process.hrtime.bigint()
    @intervalMillis = ( 60.0 / @bpm ) / @ticks * 1000.0
    # @interval = setInterval (=> @tick()), @intervalMillis
    @scheduleNext()

  tick: ->
    @counter.inc()
    @emit 'tick', @
    if (@counter.value % 2) == 0
      @emit 'tick/2', @
    if (@counter.value % 3) == 0
      @emit 'tick/3', @
    if (@counter.value % 4) == 0
      @emit 'tick/4', @


    if (@counter.value % @ticks) == 0
      @beat = Math.floor ( @counter.value / @ticks ) % @bars
      @emit 'beat', @
      @emit 'beat:'+@beat, @

    if (@counter.value % (@ticks*@beats) ) == 0
      @pos = Math.floor ( @counter.value / (@ticks*@beats) )
      @bar = Math.floor ( @counter.value / (@ticks*@beats) ) % 4
      @emit 'bar', @
      @emit 'bar:'+@bar, @

    @scheduleNext()

module.exports = {Clock}
