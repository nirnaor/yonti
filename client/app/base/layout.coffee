Marionette = require "backbone.marionette"

BaseLayout = Marionette.LayoutView.extend
  template: "base_layout"
  regions:
    header: ".bar.bar-nav"
    content: ".content"
  ui:
    header: "h1.title"
  set_header: (text)-> @ui.header.html text

module.exports =
  BaseLayout: BaseLayout
