Hammer = require "hammerjs"

add = (el, gesture_name, callback, context)->
  hammer = new Hammer(el)
  hammer.on gesture_name, (ev)=>
    callback.apply(context)
  return hammer

module.exports =
  add: add
