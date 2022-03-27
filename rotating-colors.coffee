click.bpm = 81
click.reset()

colors = [
  {dimmer:255, r: 0, g:0, b:0, a:0, w:0, uv:0}
  {dimmer:255, r: 0, g:0, b:0, a:0, w:0, uv:0}
  {dimmer:255, r: 0, g:0, b:0, a:0, w:0, uv:0}
]


process.stdin.on 'keypress', (str, key) ->
  if key.name == 'r'
    log 'reset'
    click.value = 0

  if key.name == 's'
    log 'sync'
    click.once 'beat', ->
      click.emit 'sync'

# click.on 'tick', (counter)->
#   log 'tick', {counter}

click.on 'beat:0', (event)->
  # log 'beat', {bpm: click.bpm.toFixed(3), event}
  f.set {dimmer:255, r: 0, g:0, b:0, a:0, w:0, uv:0}
  anime 
    targets: f
    r: 0
    duration: 300
    easing: 'linear'
    update: -> f.update()

click.on 'beat', (event)->
  log 'beat', {bpm: click.bpm.toFixed(3), event}

# click.on '12', ->
#   log '12', click.bpm.toFixed(3)
#   f.set {dimmer:255, r: 0 , g:0, b:0, a:0, w:0, uv:0}

# l = -> log 'counter', @value
# c.on 0, l
# .on 24, l
# .on 48, l
# .on 72, l


# f.set {dimmer:255, r: 255, g:0, b:0, a: 0, w:0, uv:0}
f.set {dimmer:255, r: 255, g:200, b:0, a:43, w:0, uv:50}

# anime
#   targets: f
#   r: 0
#   duration: 300
#   easing: 'linear'


# t.set {tilt:0, pan:0, speed: 0, dimmer: 255}
  
# r = ->t.set {r: 255, g:0, b:0, a:0}
# g = ->t.set {r:0, g: 255, b:0, a:0}
# b = ->t.set {r:0, g: 0, b:255, a:0}
# a = ->t.set {r:0, g: 0, b:0, a:255}

# rr = ->
#   t.set {r: 255, g:0, b:0, a:0}
#   anime
#     targets: t
#     r: 0
#     duration: 300
#     easing: 'linear'

#   t.set {tilt:0}
#   anime
#     targets: t
#     tilt: 60
#     duration: 200
#     easing: 'linear'


# c.on 0, rr
# .on 24, rr
# .on 48, rr
# .on 72, rr

# anime
#   targets: t
#   pan: 0
#   duration: 10000
#   easing: 'linear'
#   autoplay: true
#   loop: true
#   update: ->
#     t.update()
#     undefined


# rr()

# # t.set {dimmer:255, r: 0, g:255}
# # t.set {tilt: 0}
# # t.set {pan: 255, speed: 0}
# # dmx.update 'U0', t.dmx()

