$ = require "jquery"
_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base//base_list"
BaseLayout = require("../base/layout").BaseLayout

CategoryHeader = Marionette.ItemView.extend
  template: false
  onRender: ->
   $("<h1>").addClass("title").html("Pick a category (V0.0.4)").appendTo(@el)


CategoryItem = BaseList.ListItemView.extend
  template: "category"


CategoryListView = BaseList.ListView.extend
  initialize: (options)->
    @collection = @options.collection.categories()
      
  childView: CategoryItem
  template: false


CategoryView = BaseLayout.extend
  childEvents:
    "item_clicked": (childView, msg)->
      console.log "category clicked"
      @triggerMethod("category_picked",
        category: childView.model.get("category"))
  onRender: ->
    @header.show(new CategoryHeader())
    @content.show(new CategoryListView(collection: @options.collection))


  
 module.exports =
   View: CategoryView
  
