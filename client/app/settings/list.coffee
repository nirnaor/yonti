Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base/base_list"


SettingView = BaseList.ListItemView.extend
  template: "setting"
  item_clicked: (ev)->
    console.log "setting clicked"
    @triggerMethod "setting clicked"

SettingsCollectionView = BaseList.ListView.extend

  childView: SettingView

  childEvents:
    "setting clicked": (ev)->
      console.log "SettingsCollectionView noticed clicked"

  initialize: (options)->
    @collection = new Backbone.Collection()
    for setting in [ "edit phrases", "instant mode" ]
      @collection.add(new Backbone.Model(name: setting))



module.exports =
  View: SettingsCollectionView
