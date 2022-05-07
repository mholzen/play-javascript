require '../lib/colors'
universe = JSON.parse fs.readFileSync './universe.json'
u.set universe

click.bpm =
  # 88
  universe.bpm

t.set
  pan: 75
  tilt: 160

click.reset()

u.set gold

sequence = [
  # soft_white
  # soft_white, gold_white, gold #, pink_white
  # yellow, orange, gold, soft_white, dark_orange, soft_white, deep_orange
  gold, deep_orange, pink, dark_purple, dark_cyan, dark_green2
  # blue, red, gold, red, yellow, purple
  # blue, purple, red, yellow, green, cyan
]

sequence1 = [
  # gold, dark_orange, dark_purple, magenta, cyan, green_brown, purple, jade, yellow
  [gold, orange], dark_orange,
  [pink, magenta], {r: 64, g:20, b:255, a:0, w:0, uv:0},
  [cyan, green_brown], yellow_green,
  [purple, jade], yellow

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
targets = [t1, t2, t3, t4, f1, f2, f3, f4]

delay = (ms, f)->
  setTimeout f, ms

fillTargets = (scene, targets)->
  if not Array.isArray scene
    scene = Array(targets.length).fill scene

  while scene.length < targets.length
    scene = scene.concat scene

  scene

transitionScene = (event)->
  scene = sequence.next().value
  scene = fillTargets scene, targets
  targets.map (target, i)->
    # introduce delay based on i

    d = click.intervalMillis * 24 * i
    # d = 0
    delay d, ->
      console.log "transition", {i}
      anime Object.assign {
        targets: target
        duration: click.intervalMillis * 24 * 8
        # easing: 'linear'
        # easing: 'easeInCubic'
        easing: 'easeOutCubic'
        update: -> target.update()
      }, scene[i]

if 0 # transition scenes
  click.on 'bar', transitionScene
  # click.on 'bar:2', transitionScene

if 0 # super fast move
  u.set {speed: 0}
  click.on 'beat', (event)->
    {tilt, pan} =  t1
    # log {tilt, pan}
    u.set
      tilt: Math.random()*128 + 64
      pan: Math.random()*64

if 0 # medium continuous move
  pan = 0
  tilt = 0
  av = 4    # angular(?) velocity
  f = (move)->
    ->
      if move
        pan += Math.sign Math.random() - .5
        tilt += Math.sign Math.random() - .5
        if pan < 0
          pan = -pan
        if tilt < 0
          tilt = -tilt

      u.set {speed: 255}
      console.log {pan, tilt}
      t.set
        pan:  pan * av
        tilt: 127 + tilt * av * 3

  click.on 'beat', f 1

if 1 # slow move
  p = 0
  tilt = 0
  s = 1
  a = 1
  av = 8
  f = (move)->
    ->
      if move
        pan += Math.sign Math.random() - .5
        tilt += Math.sign Math.random() - .5
        if pan < 0
          pan = -pan
        if tilt < 0
          tilt = -tilt

      t.set
        speed: 255
        pan:  p * av
        tilt: 64 + tilt * av * 3

  click.on 'bar:0', f 1
  click.on 'beat:1', f 0

if 0 # small fast moves
  pan = 0
  tilt = 0
  av = 50

  destination = {pan: 0, tilt: 64}
  moveDestination = ->
    destination.pan += (Math.sign Math.random() - .5) * av
    destination.tilt += (Math.sign Math.random() - .5) * av
    if destination.pan < 0
      destination.pan = -destination.pan
    if destination.tilt < 0
      destination.tilt = -destination.tilt
    console.log {destination}

  increment = 1
  moveToDestination = (move)->
    ->
      if move
        if pan != destination.pan
          pan += Math.sign(destination.pan - pan) * increment
        if tilt != destination.tilt
          tilt += Math.sign(destination.tilt - tilt) * increment

      console.log {pan, tilt}
      t.set
        speed: 255
        pan: pan
        tilt: tilt

  click.on 'bar:0',  moveDestination
  click.on 'beat', moveToDestination true

if 0 # large fast moves
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

    u.set {speed: 0}
    t.set
      pan:  p * av
      tilt: 64 + tilt * av * 2

  click.on 'beat', f

rampBeats = 2
fadeIn = (event, targets)->
  u.set { dimmer: 16 }
  anime Object.assign {
    targets: targets ? [t1, t2, t3, f1, f2, f3, f4]
    # targets: targets ? u
    duration: click.intervalMillis * 24 * rampBeats
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
  }, { dimmer: 127 }
if 0 # fade in to flash
  click.on ('beat:-'+rampBeats), fadeIn   # should be 'beat:' + (4 - rampBeats)
  # delay (click.beatsMs * rampBeats), fadeIn

fadeOut = (event)->
  u.set {dimmer: 127}
  anime Object.assign {
    targets: [t1, t2, t3, f1, f2, f3, f4]
    duration: click.intervalMillis * 24 * rampBeats
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
  }, { dimmer: 16 }
if 0 # flash then fade out
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


process.stdin.on 'keypress', (str, key) ->
  #
  # CLOCK
  #
  if key.name == 'r'
    log 'reset immediately'
    click.reset()
    return

  if key.name == 's'
    log 'sync on next beat'
    click.once 'beat', ->
      click.emit 'sync'
      log 'reset'
      click.reset()
    return

  if key.sequence == '['
    click.start += 10000000n # 10,000,000 nanoseconds = 10ms
    log '+10ms'
    return
  if key.sequence == ']'
    click.start -= 10000000n
    log '-10ms'
    return
  if key.sequence == '='
    click.bpm += .25
    return
  if key.sequence == '-'
    click.bpm -= .25
    return


  #
  # TILT AND PAN
  #
  updateTiltPan = ->
    t1.update()
    t2.set {pan: t1.pan, tilt: t1.tilt}
    t3.set {pan: t1.pan, tilt: t1.tilt}
    console.log {pan: t1.pan, tilt: t1.tilt, speed: t1.speed}

  inc = 1
  inc = 32 if key.shift
  # inc = 32 if key.ctrl
  bound = (min, max, value)->
    if value < min
      return min
    if value > max
      return max
    return value

  if key.name == 'a'
    t1.tilt = bound 0, 255, t1.tilt + inc
    updateTiltPan()

  if key.name == 'z'
    t1.tilt = bound 0, 255, t1.tilt - inc
    updateTiltPan()

  if key.name == 'q'
    t1.pan = bound 0, 255, t1.pan + inc
    updateTiltPan()

  if key.name == 'w'
    t1.pan = bound 0, 255, t1.pan - inc
    updateTiltPan()

  frequencies =
    '0': []
    't': 'bar'
    'y': ['beat:0', 'beat:2']
    'u': 'beat'
    'i': ['tick:0', 'tick:12']
    'o': ['tick:0', 'tick:6', 'tick:12', 'tick:18']
    'p': 'tick'

  frequency = frequencies[key.sequence]
  if frequency?
    console.log "setting frequency to #{frequency}"
    for f in Object.values frequencies
      f = [f] if not Array.isArray f
      for p in f
        click.off p, fadeOut
    frequency = [frequency] if not Array.isArray frequency
    console.log {frequency}
    for f in frequency
      console.log "on #{f}"
      click.on f, fadeOut

  # isFadeOn = (eventName)-> click.listeners(eventName).includes(fadeOut)
  # if key.name == 'u'
  #   if isFadeOn 'bar'
  #     console.log 'off'
  #     click.off 'bar', fadeOut
  #   else
  #     console.log 'on'
  #     click.on 'bar', fadeOut

  # if key.name == 'i'
  #   if isFadeOn 'beat:0'
  #     click.off 'beat:0', fadeOut
  #     click.off 'beat:2', fadeOut
  #   else
  #     click.on 'beat:0', fadeOut
  #     click.on 'beat:2', fadeOut

  # if key.name == 'o'
  #   if isFadeOn 'beat'
  #     click.off 'beat', fadeOut
  #   else
  #     click.on 'beat', fadeOut

  # if key.name == 'p'
  #   if isFadeOn 'tick'
  #     click.off 'tick', fadeOut
  #   else
  #     click.on 'tick', fadeOut

  console.log key


# animate color
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
  #   # log 'beat', {bpm: click.bpm.toFixed(3), event}
  #   t1.set {dimmer:255, r: 0, g:0, b:0, a:0, w:0, uv:0, tilt: 127}
  #   anime 
  #     targets: t1
  #     r: 255
  #     duration: 2000
  #     easing: 'easeInBounce'
  #     update: -> t1.update()


click.on 'beat', (event)->
  console.log {
    bpm: click.bpm.toFixed(3)
    bar: event.bar
    beat: event.beat
    pos: event.pos
    beatMs: Math.round(event.intervalMicros*24/1000)
  }
