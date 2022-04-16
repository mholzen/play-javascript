#!/usr/bin/env coffee
readline = require 'readline'
fs = require 'fs'

universe = JSON.parse fs.readFileSync './universe.json'
saveUniverse = ->
  fs.writeFileSync './universe.json', JSON.stringify universe, null, 2

readline.emitKeypressEvents process.stdin
process.stdin.setRawMode true

times = []
intervals = (times)->
  times.reduce (intervals, time, i, times)->
    previous = if i == 0 then time else times[i-1]
    intervals.push time - previous
    intervals
  , []

average = (values)->
  values.reduce( ((a,b)->a + b), 0) / values.length - 1

median = (values) ->
  if values.length == 0
    return 0
  values.sort (a, b) -> a - b
  half = Math.floor values.length / 2
  if values.length % 2
    return values[half]
  (values[half - 1] + values[half]) / 2.0

iqm = (values) ->
  if values.length == 0
    return 0
  values.sort (a, b) -> a - b
  lower = Math.floor values.length * .25
  higher = Math.floor values.length * .75
  i = average values.slice lower, higher
  console.log {lower, higher}
  i
  
instructions = """
any key to tap
<r> to reset"
ctrl+c to quit
<enter> to send
"""

console.log instructions

millisToBpm = (ms)->
  f = 1000.0 / ms	# hz
  t = f * 60		  # bpm

bpm = null
process.stdin.on 'keypress', (str, key) ->
  if key.name == 'c' and key.ctrl
    process.exit()

  if key.name == 'r'
    times = []

  if key.name == 'return'
    console.log "sending"
    if bpm?
      universe.bpm = bpm
      saveUniverse()

  # TAP
  times.push (new Date()).getTime()

  i = intervals times
  ave = average i[1..]
  med = median i[1..]
  i.iqm = iqm i
  bpm = Math.round millisToBpm i.iqm

  s = []
  s.push "median: #{millisToBpm(med).toFixed(2)} [bpm] (#{med.toFixed(2)} [ms])"
  s.push "average: #{millisToBpm(ave).toFixed(2)} [bpm]"
  s.push "iqm: #{millisToBpm(i.iqm).toFixed(2)} [bpm]"
  s.push "(#{bpm} [bpm])"
  # s.push "intervals: (#{times.length} [count])"
  # s.push "[ " + (i[1..].map (i)-> i.toString().padStart 4, ' ').join(' ') + " ]"

  console.log s.join ' '

  if times.length > 20
    times.shift()
