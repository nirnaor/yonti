_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "./base_list"

MenuItem = BaseList.ListItemView.extend
  template: "category"
  events: "click .category": "on_category_clicked"
  on_category_clicked: (ev)->
    console.log "category clicked"
    @triggerMethod("category_clicked", category: @model.get("category"))


CategoryView = BaseList.ListView.extend
  initialize: (options)->
    @collection = @options.phrases.categories()
      
  childView: MenuItem
  template: false
  childEvents:
    "category_clicked": (childView, msg)->
      console.log "CategoryView noticed"
      @triggerMethod("category_picked", category: msg.category)
  
 module.exports =
   View: CategoryView
  
