Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base/base_list"


SettingView = BaseList.ListItemView.extend
  template: "setting"

SettingsCollectionView = BaseList.ListView.extend

  childView: SettingView

  childEvents:
    "item_clicked": (ev)->
      console.log "SettingsCollectionView noticed clicked"

  initialize: (options)->
    @collection = new Backbone.Collection()
    for setting in [ "edit phrases", "instant mode" ]
      @collection.add(new Backbone.Model(name: setting))



module.exports =
  View: SettingsCollectionView
