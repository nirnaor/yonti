Marionette = require "backbone.marionette"
LocalStorage = require "./local_storage"
GoogleData = require "./google_data"

DataManager = Marionette.Object.extend
  load: ->
    local_data = LocalStorage.get "phrases"
    unless typeof(local_data) is "undefined"
      @triggerMethod "load_finished", data: local_data

    data = new GoogleData.Data()
    data.on "load_finished",(ev)=>
      console.log ev.data
      @triggerMethod "load_finished", ev
    data.load()

module.exports = 
  DataManager: DataManager
