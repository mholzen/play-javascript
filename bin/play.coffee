#!/usr/bin/env coffee

midi = require 'midi'
fs = require 'fs'
CoffeeScript = require 'coffeescript'
readline = require 'readline'

Object.assign global, require '../lib/sequence'

readline.emitKeypressEvents process.stdin
process.stdin.setRawMode true
process.stdin.on 'keypress', (str, key) ->
  if key.name == 'c' and key.ctrl
    process.exit()


output = new midi.Output()
output.openVirtualPort "Node Output"

step = new StepSequencer 120, 1, [0]
step.beat = 0

mtime = 0
filename = './live.coffee'
sequencers = []

loadOnChanged = ->
  stat = fs.statSync filename
  if stat.mtime > mtime
    console.log 'reloading'
    code = fs.readFileSync filename
    mtime = stat.mtime
    sequencers.map (seq)->
      seq.stop()
    try
      sequencers = eval CoffeeScript.compile code.toString()
      sequencers.map (seq)->
        seq.play()
    catch error
      console.log error

loadOnChanged()

step.on '0', ->
  step.beat = (step.beat + 1) % 8
  console.log "beat #{step.beat+1}"
  loadOnChanged()
  # output.sendMessage noteOn 41

step.play()
