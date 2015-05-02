Backbone = require "backbone"
Marionette = require "backbone.marionette"
Requests = require "./requests"

LocalStorage = require "./local_storage"

_ = require "underscore"
Data = Marionette.Object.extend
  on_success: (data)->
    @triggerMethod "load_finished", data: data

  load: ->
    Requests.get("users_data", {},
      ( => @on_success(arguments[0])),
      ( => @fill_errors(arguments[0].responseJSON))
    )

    console.log "calling init"

module.exports = 
  Data: Data
