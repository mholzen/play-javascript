#!/usr/bin/env coffee
sequencer = require 'step-sequencer'
readline = require 'readline'

bpm = process.argv[2]
if not bpm?
  console.error "Error: missing argument <bpm>"
  console.error "Usage: bpm <bpm>"
  process.exit()

instructions = """
<r> to reset
<ctrl+c> to quit

"""
console.log instructions

bpmToMillis = (bpm)->
  frequency = bpm / 60    # hz
  period = 1 / frequency  # sec
  period * 1000

readline.emitKeypressEvents process.stdin
process.stdin.setRawMode true

counter = 0
beat = ->
  console.log counter + 1
  if counter == 3
    console.log ''
  counter = (counter + 1) % 4

f = setInterval beat, bpmToMillis bpm

process.stdin.on 'keypress', (str, key) ->
  if key.name == 'c' and key.ctrl
    process.exit()

  if key.name == 'r'
    clearInterval f
    counter = 0
    beat()
    f = setInterval beat, bpmToMillis bpm
