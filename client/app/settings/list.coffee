Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base/base_list"


GooglePhrasesView = Marionette.ItemView.extend
  template: "google"
  
SettingView = BaseList.ListItemView.extend
  template: "setting"

SettingsCollectionView = BaseList.ListView.extend

  childView: SettingView


  initialize: (options)->
    @collection = new Backbone.Collection()
    for setting in [ "edit phrases", "instant mode" ]
      @collection.add(new Backbone.Model(name: setting))

SettingsView = Marionette.LayoutView.extend
  template: "settings_layout"
  regions:
    "list": ".list"
    "google": ".google"

  childEvents:
    "item_clicked": (childView, msg)->
      name = childView.model.get("name")

      switch name
        when "edit phrases" then @show_google_phrases()
      
      console.log "SettingsCollectionView noticed clicked"

  show_google_phrases: ->
    @list.$el.hide()
    url = @options.options.data_manager.google_url
    model = new Backbone.Model(url: url)
    @google.show(new GooglePhrasesView(model: model))
  onRender: ->
    @list.show(new SettingsCollectionView())

module.exports =
  View: SettingsView
