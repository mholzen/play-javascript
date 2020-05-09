# step2 = new StepSequencer step.tempo*2, 4, [1, 2, 3, 4]
# step2.on '0', ->
#   console.log 'step2 0'

process.stdin.on 'keypress', (str, key) ->
  if key.name == 'r'
    console.log 'reset'
    step.beat = 0

{dmx, Tomshine} = require 'marc-dmx'

f = new Tomshine 1
f.set {dimmer:255, r: 0, g:255}
f.set {tilt: 0}
f.set {pan: 255, speed: 0}
dmx.update 'U0', f.dmx()

step.on '0', ->
  f.set {dimmer:255, r: 255/step.beat, g:0}
  # f.set {pan:127/step.beat }
  f.set {tilt:127/step.beat}
  dmx.update 'U0', f.dmx()


return [
  # step2
]
