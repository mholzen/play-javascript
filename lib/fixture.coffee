DMX = require 'dmx'
log = require '@vonholzen/log'
{promisify} = require 'util'
fs = require 'fs'
stat = promisify fs.stat

class Universe
  constructor: (driver, device, dmx, name)->
    {@driver, @device, @dmx, @name} = {driver, device, dmx, name}
    if not @dmx?
      @dmx = new DMX()
    if not @name?
      @name = '0'

    @universe = @dmx.addUniverse @name, @driver, @device, dmx_speed: 25

    @fixtures = []
    @logStatus()

  logStatus: ->
    s = await stat @device
    if not s.isCharacterDevice()
      log.error "file '#{@device}' is not a character device.  Make sure to quit DMXIS.", {@device}

  add: (fixtures)->
    fixtures.forEach (fixture)=>
      @fixtures.push fixture
      fixture.universe = @

  set: (args...)->
    @fixtures.map (f)->f.set args...

  update: (channels)->
    if not channels?
      channels = @fixtures.reduce ((m, f)-> Object.assign m, f.dmx()), {}
    @dmx.update @name, channels

class EntecUniverse extends Universe
  constructor: ->
    super 'enttec-usb-dmx-pro', '/dev/tty.usbserial-ENVVVCOF'

class Fixture
  constructor: (address, channels, universe)->
    if typeof address != 'number'
      throw new Error "numeric address required #{typeof address}"
    @address = address
    @channels = channels
    
    @values = []
    @channels.forEach (channel, i)=>
      @values[i] = 0
      Object.defineProperty @, channel,
        set: (value) ->
          @values[i] = value
        get: () => @values[i]
        enumerable: true

    @universe = universe

  set: (args...)->
    values = Object.assign {}, args...
    for key, value of values
      @[key] = value
    @update()

  dmx: ->
    # TODO: optimize: store values in format ready for dmx()
    r = {}
    @values.forEach (v, i)=>
        r[i+@address] = v
    r
  update: ->
    @universe.update @dmx()

  toString: ->
    joiner = (memo, value)->
      memo ?= {}
      Object.assign memo, value

    @channels.map (channel) =>
      "#{channel}:" + @[channel].toFixed(0)
    .join ' '

class FixtureSet
  constructor: (fixtures)->
    @fixtures = fixtures

  set: (args...)->
    @fixtures.map (f)->f.set args...

  update: ->
    for f in @fixtures
      f.update()

class Tomshine extends Fixture
  constructor: (address)->
    super address, [
      'pan', 'tilt', 'speed', 'dimmer', 'strobe'
      'r', 'g', 'b', 'w', 'a', 'uv'
    ]

class FreedomPar extends Fixture
  constructor: (address)->
    super address, [
      'dimmer',
      'r', 'g', 'b', 'a', 'w', 'uv',
      'strobe'
    ]

module.exports = {
  Universe
  EntecUniverse
  Fixture
  FixtureSet
  Tomshine
  FreedomPar
}