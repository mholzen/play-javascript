class Fixture
  constructor: (address, channels)->
    if typeof address != 'number'
      throw new Error "numeric address required #{typeof address}"
    @address = address
    @values = []

    channels.forEach (channel, i)=>
      @values[i] = 0
      Object.defineProperty @, channel,
        set: (value) ->
          @values[i] = value
        get: () => @values[i]
           enumerable: true
  dmx: ->
    r = {}
    @values.forEach (v, i)=>
        r[i+@address] = v
    r
  set: (values)->
    for key, value of values
      @[key] = value

class Tomshine extends Fixture
  constructor: (address)->
    super address, [
      'pan', 'tilt', 'speed', 'dimmer', 'strobe'
      'r', 'g', 'b', 'w', 'a', 'uv'
    ]

f = new Tomshine 1, [
  'pan', 'tilt', 'speed', 'dimmer',
  'r', 'g', 'b', 'w', 'a', 'uv'
]


module.exports = {Fixture, Tomshine}