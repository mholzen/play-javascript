class Chain
  constructor: (fixtures)->
    if not (fixtures instanceof Array)
      throw new Error "#{typeof fixtures} is not an Array"

    @fixtures = fixtures
    @queue = new Array @fixtures.length

  push: (color)->
    @queue.unshift color
    if @queue.length > @fixtures.length
      @queue.pop()

    log.debug 'chain', {length: @queue.length}

    @fixtures.forEach (fixture, index)=>
      # log.debug 'set', {fixture, color: @queue[index]}
      action = @queue[index]
      if typeof action == 'function'
        action.call null, fixture
      else
        fixture.set @queue[index]

module.exports = (fixtures)->
  new Chain fixtures
