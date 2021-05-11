module.exports = (array)->
  while true
    for i from array.values()
      yield i
