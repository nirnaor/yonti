Store = require "store"
module.exports =
  set: (key, value)-> Store.set(key, value)
  get: (key)-> Store.get(key)
  remove: (key)-> Store.remove(key)
