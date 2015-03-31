_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

MenuItem = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  template: "menu"


CategoryView = Marionette.CollectionView.extend
  initialize: (options)->
    @collection = @options.questions.categories()
      
  childView: MenuItem
  template: false
  className: "table-view"
  tagName: "ul"
  
 module.exports =
   CategoryView: CategoryView
  
