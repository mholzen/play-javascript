{EntecUniverse, Tomshine, FreedomPar, FixtureSet} = require './lib/fixture'
midi = require './lib/midi'
{Clock} = require './lib/clock'
log = require '@vonholzen/log'
{statSync}= require 'fs'
colors = require './lib/colors'
anime = require 'animejs'
window = {Promise}
document = null
class NodeList
class HTMLCollection
class SVGElement

u = new EntecUniverse()
calls = 0
requestAnimationFrame = (step)->
  setTimeout (-> step(new Date().getTime())), 0
  calls++

cancelAnimationFrame = (id)->
  # console.log "cancelling #{id}"

t1 = new Tomshine 1
t2 = new Tomshine 17
t3 = new Tomshine 33
t4 = new Tomshine 49

f1 = new FreedomPar 65
f2 = new FreedomPar 81
f3 = new FreedomPar 97
f4 = new FreedomPar 113

u.add [t1, t2, t3, t4, f1, f2, f3, f4]

t = new FixtureSet [t1, t2, t3, t4]
f = new FixtureSet [f1, f2, f3, f4]
s = new FixtureSet [t, f]

try
  log.debug 'trying to listen to midi click'
  click = midi.click()

  console.log "midi clock detected: using it."

catch error
  log.error {message: error.message}
  if error.message == 'no input midi ports'
    console.log "no midi clock detected (no input ports):  using internal clock"
    click = new Clock()


module.exports = {
  u
  t
  f
  t1, t2, t3, t4
  f1, f2, f3, f4
  click
  log
  anime
  window
  requestAnimationFrame
  cancelAnimationFrame
  document # needed by anime
  NodeList
  HTMLCollection
  SVGElement
  colors...
}