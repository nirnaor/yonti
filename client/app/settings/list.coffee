Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"


GooglePhrasesView = Marionette.ItemView.extend
  template: "google"
  ui:
    "mail": "a.mail"
  onRender:->
    subject = "Add Questions to your Yonti app"
    url = @model.get("url")
    body = "Click the attached to add more questions to your App. The questions will appear on your app: %0A #{url}"
    href = "mailto:?subject=#{subject}&&body=#{body}"
    @ui.mail.attr("href", href)


  
SettingView = BaseList.ListItemView.extend
  template: "setting"

SettingsCollectionView = BaseList.ListView.extend

  childView: SettingView


  initialize: (options)->
    @collection = new Backbone.Collection()
    for setting in [ "edit phrases", "instant mode" ]
      @collection.add(new Backbone.Model(name: setting))

SettingsView = BaseLayout.extend
  childEvents:
    "item_clicked": (childView, msg)->
      name = childView.model.get("name")

      switch name
        when "edit phrases" then @show_google_phrases()
      
      console.log "SettingsCollectionView noticed clicked"

  show_google_phrases: ->
    url = @options.options.data_manager.google_url
    model = new Backbone.Model(url: url)
    @content.show(new GooglePhrasesView(model: model))
    @set_header "Edit phrases"
  onRender: ->
    # @show_google_phrases()
    @content.show(new SettingsCollectionView())
    @set_header "Settings"

module.exports =
  View: SettingsView
