Marionette = require "backbone.marionette"

Gestures = require "./../lib/gestures"


BaseLayout = Marionette.LayoutView.extend
  template: "base_layout"
  regions:
    header: ".bar.bar-nav h1"
    content: ".content"
  ui:
    header: "h1.title"
    back: ".icon-left-nav"
    show_settings: "a.icon-gear"
  set_header: (text)-> @ui.header.html text
  onRender: ->
    Gestures.add(@ui.back.get(0), "tap", @on_back_clicked, @)
    Gestures.add(@ui.show_settings.get(0), "tap", @on_show_settings_clicked, @)
  on_back_clicked: ->
    console.log "needs implementing on parent"



module.exports =
  BaseLayout: BaseLayout
