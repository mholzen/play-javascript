DMX = require 'dmx'
midi = require './lib/midi'
{Fixture, Tomshine} = require './lib/fixture'

dmx = new DMX()
universe = dmx.addUniverse 'U0', 'enttec-usb-dmx-pro', '/dev/tty.usbserial-ENVVVCOF', easing: 'inQuad'

f = new Tomshine 1
f.set {r: 1, g: 2, b: 3}
f.set {pan:0, tilt: 127, speed: 0}

# dmx.update 'U0', {
#   1: 0
#   2: 127
#   3: 0
#   4: 255
#   5: 0
#   6: 255
# }

# red = {
#   1: 0
#   2: 127
#   3: 0
#   4: 255
#   5: 0
#   6: 255
#   7: 0
#   8: 0
# }

# green = {
#   1: 0
#   2: 127
#   3: 0
#   4: 255
#   5: 0
#   6: 0
#   7: 255
#   8: 0
# }

# blue = {
#   1: 0
#   2: 127
#   3: 0
#   4: 255
#   5: 0
#   6: 0
#   7: 0
#   8: 255
# }

# a = new DMX.Animation()
# .add red, 2000, easing: 'inQuad'
# .add green, 2000, easing: 'inQuad'
# .add blue, 2000, easing: 'inQuad'
# .runLoop universe

module.exports = {midi, dmx, Fixture, Tomshine}