Marionette = require "backbone.marionette"
Data = Marionette.Object.extend
  showInfo: (data, tabletop)->
    @triggerMethod "load_finished", data: data
  load: ->
    public_spreadsheet_url = "https://docs.google.com/spreadsheets/d/1tbNkD6NIozNB4nywTNdNGDhVyFcFlk-arOHG3oTqTho/pubhtml?gid=1987288858&single=true"
    console.log "calling init"
    Tabletop.init( key: public_spreadsheet_url,    callback: ( (data, tabletop)=> @showInfo(data)),simpleSheet: true)

module.exports = 
  Data: Data
