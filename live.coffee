require '../lib/colors'

# ideas: beat:1,3 pan: 255 beat: 2,4 pan:0

click.bpm =
  30
  # 89 # Channel Tres - Black Moses , RTJ - out of sight
  # 119 # Channel Tres - Glide
  # 144

click.reset()

u.set {dimmer:255, tilt: 127, pan: 0, speed: 0}

osum = (a,b)->
  r = Object.keys(a)
  .map (k)-> {[k]: (a[k] ? 0) + (b[k] ? 0) }
  Object.assign {}, r...

objectsSum = (objects)->
  r = objects.reduce osum, black
  for k of r
    r[k] = r[k] / objects.length
  r

argSum = ->
  objectsSum Array.from arguments

dark_orange = argSum orange, black
dark_green = argSum green, black
deep_orange = argSum yellow, red, red
# u.set {r: 64, g:20, b:255, a:0, w:0, uv:0}
u.set soft_white
# u.set orange
# u.set objectsSum [ red, orange ]

sequence = [
  # soft_white
  soft_white, gold_white, pink_white
  # yellow, orange, gold, soft_white, dark_orange, soft_white, deep_orange
]

sequence1 = [
  # gold, dark_orange, dark_purple, magenta, cyan, green_brown, purple, jade, yellow
  [gold, orange], dark_orange,
  [pink, magenta], {r: 64, g:20, b:255, a:0, w:0, uv:0},
  [cyan, green_brown], yellow_green,
  [purple, jade], yellow

  # red

  # black
  # soft_white

  # soft_white, gold_white, dark_orange, gold, yellow
  # green, blue, red
  # gold_white
  # yellow
  # gold
  # candle
  # [dark_green, dark_red, dark_green, dark_red]
  # [dark_red, dark_green, dark_red, dark_green]

  # [soft_white, gold, soft_white, gold]
  # [gold, soft_white, gold, soft_white]

  # EXCELLENT:
  # gold, dark_orange, gold_white, yellow, jade, indigo_web, purple, dark_purple

  # dark_orange, dark_purple, dark_red, dark_blue

  # gold, black, dark_orange, black, dark_orange, black, dark_purple
  
  # [jade, purple, jade, purple],
  # [purple, jade, purple, jade],

  # blue, violet, red, purple, cyan, jade, dark_orange, gold, yellow, green_brown
  # dark_purple
  # red, dark_purple
  # {r: 0, g:0, b:10, a:0, w:0, uv:0}
]

sequence = circuit sequence
targets = [f1, f2, f3, f4, t1, t2, t3, t4]
c1 = chain [t1, t2, t3, t4]

if 1 then click.on 'bar:0', (event)->
  scene = sequence.next().value

  if not Array.isArray scene
    scene = Array(targets.length).fill scene

  while scene.length < targets.length
    scene = scene.concat scene

  if 1 # transition scenes
    targets.map (target,i)->
      anime Object.assign {
        targets: target
        duration: click.intervalMillis * 32 * 16
        # easing: 'linear'
        # easing: 'easeInCubic'
        easing: 'easeOutCubic'
        update: ->
          target.update()
          # u.update()
      }, scene[i]

  if 0 # set - TODO: should this be moved out
    targets.forEach (target, i)->
      target.set scene[i]

  if 0
    f = (target)->
      anime Object.assign {
        targets: target
        duration: click.intervalMillis * 32
        # easing: 'linear'
        easing: 'easeInCubic'
        update: -> target.update()
      }, scene[0]

    c1.push f
    u.update()

if 0 # super fast move
  u.set {speed: 0}
  click.on 'beat', (event)->
    {tilt, pan} =  t1
    # log {tilt, pan}
    u.set
      tilt: Math.random()*128 + 64
      pan: Math.random()*64

if 0 # slow move
  p = 0
  tilt = 0
  s = 1
  a = 1
  av = 8
  f = (move)->
    ->
      if move
        p += Math.sign Math.random() - .5
        tilt += Math.sign Math.random() - .5
        if p < 0
          p = -p
        if tilt < 0
          tilt = -tilt

      u.set {speed: 255}
      t.set
        pan:  p * av
        tilt: 64 + tilt * av * 3

  click.on 'beat:0', f 1
  click.on 'beat:2', f 0

if 0 # fast move
  p = 0
  tilt = 0
  s = 1
  a = 1
  av = 14
  f = (event)->
    p += Math.sign Math.random() - .5
    tilt += Math.sign Math.random() - .5
    if p < 0
      p = -p
    if tilt < 0
      tilt = -tilt

    u.set {speed: 255}
    t.set
      pan:  p * av
      tilt: 64 + tilt * av * 2

  click.on 'beat', f

if 0 # flash then fade out
  fadeOut = (event)->
    u.set {dimmer: 255}
    log 'fade out'
    anime Object.assign {
      targets: [t1, t2, t3, f1, f2, f3, f4]
      duration: click.intervalMillis * 16 * 8
      # easing: 'linear'
      easing: 'easeOutSine'
      # easing: 'easeOutCirc'
      # easing: 'easeInOutSine'
      update: ->
        t1.update()
        t2.update()
        t3.update()
        f1.update()
        f2.update()
        f3.update()
        f4.update()
    }, { dimmer: 1 }

  click.on 'bar', fadeOut

  # click.on 'beat:0', fadeOut
  # click.on 'beat:2', fadeOut

  # click.on 'beat', fadeOut

  # click.on 'tick', fadeOut

  # click.on 'bar:2', f
  # click.on 'tick:12', f
  # click.on 'tick:0', f
  # click.on 'tick:6', f
  # click.on 'bar:2', f
  # click.on 'bar', f
  # click.on 'beat', f


# sequence = circuit [ jade, purple ]
# click.on 'beat', (event)->
#   scene = sequence.next().value
#   t1.set scene
#   u.update()

# c = circuit [red, gold, purple, violet]
# c1 = chain [t1, t2, t3, t4]
# click.on 'beat', (event)->
#   c1.push c.next().value
#   u.update()

process.stdin.on 'keypress', (str, key) ->
  if key.name == 'r'
    log 'reset'
    click.reset()
    return

  if key.name == 's'
    log 'sync'
    click.once 'beat', ->
      click.emit 'sync'
      click.reset()
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
  console.log 'beat', {
    bpm: click.bpm.toFixed(3)
    bar: event.bar
    beat: event.beat
    pos: event.position
    intervalMs: event.intervalMillis?.toPrecision(2)
  }
#   u.update()

  # log {
  #   t1: t1.r.toFixed().padStart(3, ' ')
  #   t2: t2.r.toFixed().padStart(3, ' ')
  #   t3: t3.r.toFixed().padStart(3, ' ')
  #   t4: t4.r.toFixed().padStart(3, ' ')
  # }
  # log 't1', t1.toString()
  # log 't2', t2.toString()

# click.on 'bar', (event)->
#   log 'bar ', {bpm: click.bpm.toFixed(3), bar: event.bar}


# log.time = (f)->
#   start = process.hrtime()  # use bigint()
#   res = f()
#   end = process.hrtime()
#   duration = ((end[0]-start[0])*10000000000 + (end[1]-start[1])) / 1000
#   log.debug 'end', {duration: duration + 'µs'}
#   return res
