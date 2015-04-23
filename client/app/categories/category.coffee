$ = require "jquery"
_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base//base_list"
BaseLayout = require("../base/layout").BaseLayout


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
  on_back_clicked: -> @triggerMethod "category_back_clicked"
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "What do you want to learn?"
    @content.show(new CategoryListView(collection: @options.collection))
  on_show_settings_clicked: ->
    @triggerMethod "show_settings_clicked"


  
 module.exports =
   View: CategoryView
  
