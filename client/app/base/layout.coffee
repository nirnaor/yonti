Marionette = require "backbone.marionette"

BaseLayout = Marionette.LayoutView.extend
  template: "base_layout"
  regions:
    header: ".bar.bar-nav"
    content: ".content"

module.exports =
  BaseLayout: BaseLayout
