Marionette = require "backbone.marionette"
LocalStorage = require "./local_storage"
Data = require "./data"

DataManager = Marionette.Object.extend
  load: ->
    data = new Data.Data()
    data.on "load_finished",(ev)=>
      console.log ev.data
      @triggerMethod "load_finished", ev
    data.load()

module.exports = 
  DataManager: DataManager
