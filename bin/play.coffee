#!/usr/bin/env coffee

midi = require 'midi'
fs = require 'fs'
CoffeeScript = require 'coffeescript'
readline = require 'readline'

# Object.assign global, require '../lib/index'
Object.assign global, require '../lib'
Object.assign global, require '../scene'

readline.emitKeypressEvents process.stdin

# TODO: only setRawMode if stdin is a terminal
if typeof process.stdin.setRawMode == 'function'
  process.stdin.setRawMode true
  process.stdin.on 'keypress', (str, key) ->
    if key.name == 'c' and key.ctrl
      console.log "exiting"
      process.exit()

filename = './live.coffee'
load = ->
  log 'loading'
  code = fs.readFileSync filename
  try
    compiled = CoffeeScript.compile code.toString()   # TODO: is there a stage for JS compilation?

    # CLEAN UP    
    click.removeAllListeners()  # TODO: could be done in ./live

    log 'stdin listeners', process.stdin.listenerCount()
    process.stdin.removeAllListeners 'keypress'   # removing all listeners disables stdin

    # re-install critical
    process.stdin.on 'keypress', (str, key) ->
      if key.name == 'c' and key.ctrl
        process.exit()

    eval compiled
  catch error
    console.log error
    log.error error

fs.watchFile filename, {interval: 100}, load
fs.watchFile './lib/colors.coffee', {interval: 100}, load
fs.watchFile './lib/clock.coffee', {interval: 100}, load
load()

process.on 'uncaughtException', (error)->
  console.log error
  log.error error