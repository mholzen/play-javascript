delay = (ms, f)->
  setTimeout f, ms

fillTargets = (scene, targets)->
  if not Array.isArray scene
    scene = Array(targets.length).fill scene

  while scene.length < targets.length
    scene = scene.concat scene

  scene

transitionScene = (sequence, targets)->
  (event)->
    scene = sequence.next().value
    scene = fillTargets scene, targets
    targets.map (target, i)->
      # introduce delay based on i

      d = click.intervalMillis * 24 * 4 * i
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

module.exports = {
  delay
  transitionScene
  fadeIn
  fadeOut
}