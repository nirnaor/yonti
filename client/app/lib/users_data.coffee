Backbone = require "backbone"
Marionette = require "backbone.marionette"
Requests = require "./requests"

LocalStorage = require "./local_storage"

_ = require "underscore"
Data = Marionette.Object.extend
  on_success: (data)->
    results = _(data).map (phrases_array, username, list) ->
      phrases_array.map (phrase, index, inner_list) ->
        {phrase: phrase[0],meaning: phrase[1],
        category: phrase[2]}

    res = []
    res = res.concat.apply(res, results)
    console.log res
    LocalStorage.set("phrases", res)
    @triggerMethod "load_finished", data: res

  load: ->
    Requests.get("users_data", {},
      ( => @on_success(arguments[0])),
      ( => @fill_errors(arguments[0].responseJSON))
    )

    console.log "calling init"

module.exports = 
  Data: Data
