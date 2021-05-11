{circuit} = require '../lib'

describe 'circuit', ->
  it 'works', ->
    l = circuit [1,2,3]
    expect l.next().value
    .eql 1
    expect l.next().value
    .eql 2
    expect l.next().value
    .eql 3
    expect l.next().value
    .eql 1