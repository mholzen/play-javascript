StepSequencer = require 'step-sequencer'

noteOn = (note, velocity=100) -> [144, note, velocity]
noteOff = (note, velocity=0) -> [144, note, velocity]

sequence = [
  noteOn 41
  noteOff 41
  noteOn 41, 75
  noteOff 41
]

play = (output, sequence, interval)->
  message = sequence.shift()
  if typeof message == 'undefined'
    return
  console.log message
  output.sendMessage message
  f = -> play output, sequence, interval
  setTimeout f, interval

module.exports = {sequence, play, StepSequencer, noteOn, noteOff}
