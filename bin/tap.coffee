#!/usr/bin/env coffee
readline = require 'readline'
fs = require 'fs'

universe = JSON.parse fs.readFileSync './universe.json'
saveUniverse = ->
  console.log 'saving'
  fs.writeFileSync './universe.json', JSON.stringify universe, null, 2

readline.emitKeypressEvents process.stdin
process.stdin.setRawMode true

times = []

intervals = (times)->
  r = []
  for v, i in times[1..]
    r.push v - times[i]
  r

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
  i

jitter = (array)->
  d = 0
  if array.length < 1
    return NaN
  for v, i in array[1..]
    d += Math.abs v - array[i]
  d/(array.length-1)

millisToBpm = (ms)->
  f = 1000.0 / ms	# hz
  t = f * 60		  # bpm

class Series
  constructor: (@times)->
    @count = @times.length
    @intervals = intervals @times
    @jitter = jitter @intervals
    @average = average @intervals[1..]
    @median = median @intervals[1..]
    @iqm = iqm @intervals
    @bpm = Math.round millisToBpm @iqm
  jitterString: -> "#{@jitter.toFixed(2)} [ms]"
  jitterPercentage: -> "#{(@jitter / @iqm).toFixed(2)}%"


instructions = """
any key to tap
<r> to reset"
ctrl+c to quit
<enter> to send
"""
console.log instructions

bpm = null
process.stdin.on 'keypress', (str, key) ->
  if key.name == 'c' and key.ctrl
    process.exit()

  if key.name == 'r'
    times = []

  if key.name == 'return'
    console.log "sending #{bpm}"
    if bpm?
      universe.bpm = bpm
      saveUniverse()
      return

  # save a timestamp
  times.push (new Date()).getTime()
  if times.length > 20
    times.shift()

  result = new Series times
  console.log
    count: result.count
    jitter: result.jitterString()
    percentage: result.jitterPercentage()
    bpm: result.bpm

  bpm = result.bpm