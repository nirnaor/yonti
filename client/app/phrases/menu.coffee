_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

MenuItem = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  template: "menu"


CategoryView = Marionette.CollectionView.extend
  initialize: (options)->
    categories = _(@options.questions.models).map (phrase)->
      phrase.get("category")
    models = _(categories).uniq().map (category)-> category: category
    @collection = new Backbone.Collection(models)
      
  childView: MenuItem
  template: false
  className: "table-view"
  tagName: "ul"
  
 module.exports =
   CategoryView: CategoryView
  
