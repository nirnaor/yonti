_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

MenuItem = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  template: "category"


CategoryView = Marionette.CollectionView.extend
  initialize: (options)->
    @collection = @options.phrases.categories()
      
  childView: MenuItem
  template: false
  className: "table-view"
  tagName: "ul"
  
 module.exports =
   View: CategoryView
  
