EventEmitter = require 'events'
midi = require 'midi'
log = require '@vonholzen/log'
{Counter} = require './counter'

# Set up a new input
# input = new midi.Input()

f = (input, count = 0)->
  while input.getPortCount() > count
    log "opening port #{count}"
    input.openPort count
    count = f input, count+1
  count

ports = []
g = ->
  portCount = input.getPortCount()
  log.debug {portCount}
  if portCount != ports.length
    log "new port count", {portCount}

  if portCount > 0
    for i in [0..portCount-1]
      try
        log.debug input.getPortName i
        input.openPort i
      catch error
        log.debug {error}

# port = 0
# beat = 0

# input.on 'message', (deltaTime, message) ->
#   if message[0] == 250
#     beat = 0
#     return
    
#   if message[0] == 248
#     beat = (beat + 1) % 24 
#     if beat == 0
#       bpm = 60/(deltaTime*24)
#       log "beat", bpm.toFixed(3)
#     return
  
#   log "m: #{message} d: #{deltaTime}"

# # Open the first available input port.
# log "port count: " + input.getPortCount()

getPortNames = (input)->
  if input.getPortCount() == 0
    return []
  (input.getPortName(i) for i in [0..input.getPortCount()-1])


class Click extends EventEmitter
  constructor: ->
    super()
    @input = new midi.Input()
    if @input.getPortCount() == 0
      throw new Error "no input midi ports"
    @input.openPort 0

    # Sysex, timing, and active sensing messages are ignored
    # by default. To enable these message types, pass false for
    # the appropriate type in the function below.
    # Order: (Sysex, Timing, Active Sensing)
    # For example if you want to receive only MIDI Clock beats
    # you should use
    # input.ignoreTypes(true, false, true)
    @input.ignoreTypes false, false, false

    @beat = 0
    @beats = 4
    @bar = 0
    @bars = 4
    @bpm = 0
    @position = 0
    @ticks = 24

    @input.on 'message', (deltaTime, message) =>
      if message[0] == 250
        @reset()
        @emit 'sync'
        return

      if message[0] == 248
        @position += 1
        @emit 'tick'
        @emit 'tick:' + (@position % @ticks)

        if (@position % (@ticks*@beats) ) == 0
          @bar = Math.floor ( @position / (@ticks*@beats) ) % @beats
          @beat = Math.floor ( @position / @ticks ) % @bars
          @emit 'bar', @
          @emit 'bar:'+@bar, @

        if (@position % @ticks) == 0
          @bpm = 60/(deltaTime*24)
          @intervalMillis = ( 60.0 / @bpm ) / @ticks * 1000.0

          @beat = Math.floor ( @position / @ticks ) % @bars
          @emit 'beat', @
          @emit 'beat:'+@beat, @


        return

  reset: ->
    @beat = 0
    @bar = 0
    @position = 0

  counter: (max)->
    counter = new Counter max
    @on 'tick', ->
      counter.inc()
    @on 'sync', ->
      counter.value = 0
    counter

click = ->
  new Click()

module.exports = {
  click
}