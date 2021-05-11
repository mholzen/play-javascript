click.bpm = 120
click.reset()

u.set {dimmer:255, tilt: 127, pan: 0, speed: 255}

sequence = [
  red
  blue
  # black
  # {dimmer: 255}
  # softWhite

  # goldWhite
  # {r: 255, g:100, b:127, a:36, w:72, uv:0}

  # softWhite
  # goldDeep
  # softWhite, goldDeep
  # goldDeep, dark_orange
  # goldDeep, dark_orange, jade, dark_orange
  # goldDeep, black, dark_orange, black, dark_orange, black, darkPurple

  # dark_red, black, pink, black, purple, black, dark_green, black

  # jade, purple

  # red
  # darkPurple
  # red, darkPurple
  # {r: 0, g:0, b:10, a:0, w:0, uv:0}

  # purple
  # darkPink
  # jade
  # indigo_web
  # dark_orange
  # yellow
  # red
  # blue
  # cyan
  # green

  # dark_orange, goldDeep, purple
  # blue

  # pinkWhite
  # red
  # violet
  # darkPurple
  # darkPink
  # purple
  # jade
  # indigo_web
  # dark_orange
  # yellow
  # blue
  # [yellow, blue]
  # [blue, yellow]
  # cyan
  # green
  # {r:125, g:255, b:22, w: 50, a: 110}
  # {r:60, g:60, b:255, w: 0, a:0, uv: 255}
  # {r:255, g:15, b:22, w: 50, a: 110}
  # uv
]

# sequence2 = circuit sequence

index = 0
targets = [f1, t1]
# targets = [t1]
# click.on 'bar', (event)->
#   scene = sequence[index]
#   index = (index+1) % sequence.length
#   # scene = sequence2.next().value

#   if not Array.isArray scene
#     scene = Array(targets.length).fill scene

#   targets.map (target,i)->
#     anime Object.assign {
#       targets: target
#       duration: click.intervalMillis * 8
#       # easing: 'linear'
#       easing: 'easeInSine'
#       update: ->
#         target.update()
#     }, scene[i]

c = circuit [red, green, blue, black]
c1 = chain [t1, t2]
click.on 'beat', (event)->
  c1.push c.next().value


if false
  click.on 'bar:0', (event)->
    u.set
      tilt: Math.random()*64 + 128
      pan: Math.random()*10

if false
  click.on 'bar:0', (event)->
    u.set
      tilt: 80
      pan: Math.random()*64


    # anime Object.assign {
    #   targets: u
    #   duration: click.intervalMillis*click.ticks * 20
    #   easing: 'linear'
    #   update: ->
    #     target.update()
    # }, 
    #   tilt: Math.random()*64 + 128
    #   pan: Math.random()*10


process.stdin.on 'keypress', (str, key) ->
  if key.name == 'r'
    log 'reset'
    click.value = 0
    return

  if key.name == 's'
    log 'sync'
    click.once 'beat', ->
      click.emit 'sync'
    return

  if key.name == 'a'
    t1.tilt = ( t1.tilt + 1 ) % 250

  if key.name == 'z'
    t1.tilt = ( t1.tilt - 1 ) % 250

  if key.name == 'q'
    t1.pan = ( t1.pan + 1 ) % 250

  if key.name == 'w'
    t1.pan = ( t1.pan - 1 ) % 250

  t1.update()
  log.debug {pan: t1.pan, tilt: t1.tilt}


# click.on 'tick', (counter)->
#   log 'tick', {counter}


# click.on 'beat:0', (event)->
#   t1.set red
#   a = Object.assign {
#     targets: t1
#     duration: 2000
#     easing: 'easeIn'
#     update: ->
#       t1.update()
#   }, blue
#   anime a

# click.on 'beat:2', (event)->
#   t1.set blue
#   anime 
#     targets: t1
#     red
#     duration: 2000
#     easing: 'easeIn'
#     update: -> t1.update()


# click.on 'beat:0', (event)->
#   t1.set {dimmer:255, r: 255, g:0, b:0, a:0, w:0, uv:0, tilt: 127}

# click.on 'beat:0', (event)->
#   # log 'beat', {bpm: click.bpm.toFixed(3), event}
#   t1.set {dimmer:255, r: 0, g:0, b:0, a:0, w:0, uv:0, tilt: 127}
#   anime 
#     targets: t1
#     r: 255
#     duration: 2000
#     easing: 'easeInBounce'
#     update: -> t1.update()


click.on 'beat', (event)->
  # log 'beat', {bpm: click.bpm.toFixed(3), beat: event.beat, intervalMs: event.intervalMillis.toPrecision(2)}
  log 't1', t1.toString()
  log 't2', t2.toString()

# click.on 'bar', (event)->
#   log 'bar ', {bpm: click.bpm.toFixed(3), bar: event.bar}
