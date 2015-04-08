Marionette = require "backbone.marionette"
LocalStorage = require "./local_storage"
Data = Marionette.Object.extend
  showInfo: (data, tabletop)->
    LocalStorage.set("phrases", data)
    @triggerMethod "load_finished", data: data
  load: ->
    public_spreadsheet_url = "https://docs.google.com/spreadsheets/d/1tbNkD6NIozNB4nywTNdNGDhVyFcFlk-arOHG3oTqTho/pubhtml?gid=1987288858&single=true"
    console.log "calling init"
    Tabletop.init( key: public_spreadsheet_url,    callback: ( (data, tabletop)=> @showInfo(data)),simpleSheet: true)

module.exports = 
  Data: Data
