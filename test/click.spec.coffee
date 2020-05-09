{midi} = require '../'

describe 'click', ->
  it 'acquires click', ->
    click = midi.click()
    expect(click).respondTo 'on'