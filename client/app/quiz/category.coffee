_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "./base_list"

MenuItem = BaseList.ListItemView.extend
  template: "category"


CategoryView = BaseList.ListView.extend
  initialize: (options)->
    @collection = @options.phrases.categories()
      
  childView: MenuItem
  template: false
  
 module.exports =
   View: CategoryView
  
