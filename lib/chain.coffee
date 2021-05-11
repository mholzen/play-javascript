class Chain
  constructor: (fixtures)->
    if not (fixtures instanceof Array)
      throw new Error "#{typeof fixtures} is not an Array"

    @fixtures = fixtures
    @queue = new Array @fixtures.length

  push: (color)->
    @queue.unshift color
    log 'push', {queue: @queue}
    if @queue.length >= @fixtures.length
      @queue.pop()

    @fixtures.forEach (fixture, index)=>
      log 'set', {fixture, color: @queue[index]}
      fixture.set @queue[index]

module.exports = (fixtures)->
  new Chain fixtures
