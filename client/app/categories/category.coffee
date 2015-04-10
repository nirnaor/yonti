$ = require "jquery"
_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base//base_list"
BaseLayout = require("../base/layout").BaseLayout

CategoryHeader = Marionette.ItemView.extend
  template: false
  onRender: ->
   $("<h1>").addClass("title").html("Pick a category").appendTo(@el)
   $("<h4>").html("V0.0.2").appendTo @el


CategoryItem = BaseList.ListItemView.extend
  template: "category"
  item_clicked: (ev)->
    console.log "category clicked"
    @triggerMethod("category_clicked", category: @model.get("category"))


CategoryListView = BaseList.ListView.extend
  initialize: (options)->
    @collection = @options.collection.categories()
      
  childView: CategoryItem
  template: false


CategoryView = BaseLayout.extend
  childEvents:
    "category_clicked": (childView, msg)->
      @triggerMethod("category_picked", msg)
  onRender: ->
    @header.show(new CategoryHeader())
    @content.show(new CategoryListView(collection: @options.collection))


  
 module.exports =
   View: CategoryView
  
