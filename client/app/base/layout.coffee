Marionette = require "backbone.marionette"

Gestures = require "./../lib/gestures"
Stack = require "./../lib/stack"


BaseLayout = Marionette.LayoutView.extend
  template: "base_layout"
  regions:
    header: ".bar.bar-nav h1"
    settings: ".settings"
    content: ".content"
    bla: ".bla"
  ui:
    header: "h1.title"
    back: ".icon-left-nav"
    show_settings: "a.icon-gear"
  set_header: (text)-> @ui.header.html text
  onRender: ->
    @content_views = new Stack()
    Gestures.add(@ui.back.get(0), "tap", @on_back_clicked, @)
    Gestures.add(@ui.show_settings.get(0), "tap", @show_settings, @)
  on_back_clicked: ->
    console.log "BaseLayout on back clicked"

    # Remove the current view
    @content_views.pop()

    # Get the previous view
    previous_view_config = @content_views.pop()
    if typeof(previous_view_config) is "undefined"
      @back_clicked_no_previous()
    else
      @fill_content(previous_view_config)

  fill_content: (view_config)->
    console.log "this is fill content"
    @content_views.push view_config
    args = view_config.args or []
    @content.show(new view_config.view(args))

  back_clicked_no_previous: ->
    console.log "needs implementing on parent"
    app.vent.trigger("no_back_implemented")





module.exports =
  BaseLayout: BaseLayout
