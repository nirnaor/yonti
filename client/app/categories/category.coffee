$ = require "jquery"
_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base//base_list"
BaseLayout = require("../base/layout").BaseLayout
Question = require("../quiz/question")

Category = Backbone.Model.extend

CategoryItem = BaseList.ListItemView.extend
  template: "category"


CategoryListView = BaseList.ListView.extend
  childView: CategoryItem
  template: false



CategoryView = BaseLayout.extend
  childEvents:
    "item_clicked": (childView, msg)->
      console.log "category clicked"
      @triggerMethod("category_picked",    category: childView.model)
    
  on_back_clicked: -> @triggerMethod "category_back_clicked"
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "What do you want to learn?"
    @content.show(new CategoryListView(collection: @options.collection))

collection_from_raw = (raw_categories)->
  categories = new Backbone.Collection()
  for category_name, category_phrases of raw_categories
    category = new Backbone.Model(
      name: category_name,
      questions: new Question.Collection(category_phrases)
    )
    categories.add(category)

  categories

  
 module.exports =
   View: CategoryView
   Model: Category
   collection_from_raw: collection_from_raw
  
