Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"
LocalStorage = require "../lib/local_storage"


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

GoogleLayoutView = BaseLayout.extend
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "blat"
    @content.show(new GooglePhrasesView(model: @options.model))

  


  

InstantView = BaseList.ListItemView.extend
  template: "instant"
  ui: toggle: ".toggle"
  events: "toggle @ui.toggle": "instant_change"
  instant_change: (ev)->
    res = ev.originalEvent.detail.isActive
    LocalStorage.set("instant_mode", res)

  initialize: ->
    @instant = @options.instant
  onRender: -> if @instant then @ui.toggle.addClass("active")


SettingsListView = BaseList.ListView.extend
  onRender: ->
    console.log "WT"
    @$el.append(new InstantView(instant: @options.instant).render().el)

    edit_phrases = new BaseList.ListItemView(text: "Edit phrases")
    edit_phrases.on "item_clicked", => @triggerMethod "edit_phrases"
    @$el.append(edit_phrases.render().el)

    user_management = new BaseList.ListItemView(text: "Login/Logout/Signup")
    user_management.on "item_clicked", => 
      @triggerMethod "login_logout_clicked"

    @$el.append(user_management.render().el)



SettingsView = BaseLayout.extend
  childEvents:
    login_logout_clicked: (childView, msg)->
      @triggerMethod "login_logout_clicked"
  show_google_phrases: ->
    url = app.current_user().get("google_url")
    model = new Backbone.Model(url: url)
    @content.show(new GooglePhrasesView(model: model))
    @set_header "Edit phrases"
    @previous_view = "settings"
  show_settings: ->
    settings_list = new SettingsListView(instant: @options.instant)
    settings_list.on "edit_phrases", => @show_google_phrases()
    @content.show(settings_list)
    @set_header "Settings"
    @previous_view = undefined
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @show_settings()

  on_back_clicked: ->
    if @previous_view is "settings"
      @show_settings()
    else
      @triggerMethod "show_categories_clicked"
  on_show_settings_clicked: ->
    console.log "will show settings"

module.exports =
  View: SettingsView
  GoogleLayoutView: GoogleLayoutView
