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
  childEvents:
    item_clicked: (childView, msg)->
      console.log "CategoryListView: item clicked"
      @triggerMethod "category_picked", category: childView.model



CategoryView = BaseLayout.extend
  childEvents:
    "item_clicked": (childView, msg)->
      console.log "category clicked"
      @triggerMethod("category_picked",    category: childView.model)
    

  # Each user has automatically 3 sample tests. 
  # This method is to make sure that just these tests don't appear
  # more than once
  _remove_duplicate_sample_tests: (collection)->

    # Get only the categories that contain the "Yonti example" string
    all_sample_tests = collection.filter (category) ->
      category.get("name").indexOf(" Yonti example") > -1

    sample_names = all_sample_tests.map (category) -> category.get("name")


    # Create a new collection and add the smaple tests only once
    result_collection = new Backbone.Collection()

    # This dict is used to add keys of the result names. If a key will exist
    # it means that the sample test was already added
    sample_keys_dict = {}

    collection.forEach (category)->
      name = category.get("name")
      if _(sample_names).contains name
        if typeof(sample_keys_dict[name]) is "undefined"
          # Mark the name as taken and add it to the collection
          sample_keys_dict[name] = 1
          result_collection.add category
      else
        # If it's not a sample test it should be added anyway
        result_collection.add category

    result_collection


  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "What do you want to learn?"
    unique_sample_tests = @_remove_duplicate_sample_tests(@options.collection)
    @content.show(new CategoryListView(collection: unique_sample_tests))

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
   ListView: CategoryListView
   Model: Category
   collection_from_raw: collection_from_raw
  
