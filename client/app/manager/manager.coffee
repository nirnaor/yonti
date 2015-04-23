Marionette = require "backbone.marionette"

CategoryView = require("../categories/category").View
QuizView = require("../quiz/quiz").QuizView
SettingsView = require("../settings/list").View
LocalStorage = require "../lib/local_storage"

TestKindPickerView = require "./test_kind_picker"

ManagerView = Marionette.LayoutView.extend
  template: "manager_layout"

  regions:
    "tests_kinds": ".tests_kinds"
    "categories": ".categories"
    "quiz": ".quiz"
    "settings": ".settings"

  childEvents:
    "category_back_clicked": ->
      @show_test_kind_picker()
    "community_clicked": (childView, msg)->
      @show_categories()
    "category_picked": (childView, msg)->
      console.log "category #{msg.category} picked"
      @show_quiz(msg.category)
    "show_categories_clicked": (childView, msg)->
      @show_categories()
    "show_settings_clicked": (childView, msg)->
      console.log "will show settings"
      @show_settings()

  is_instant: ->
    instant = LocalStorage.get("instant_mode")
    if typeof(instant) is "undefined"
      instant = true
    instant

  onRender: -> @show_categories()
  onRender: -> @show_test_kind_picker()
  # onRender: -> @show_quiz("medicine 2")
  # onRender: -> @show_settings()

  show_categories: ->
    @quiz.$el.hide()
    if typeof(@settings.$el) isnt "undefined" then @settings.$el.hide()
    @categories.show(new CategoryView(collection: @options.collection))
    @categories.$el.show()
    console.log "this is manager"

  show_quiz: (category)->
    @categories.$el.hide()
    questions = @options.collection.by_category(category)
    @categories.reset()
    quiz_view = new QuizView(collection: questions, category: category, instant: @is_instant())

    @quiz.show(quiz_view)
    @quiz.$el.show()

  show_settings: ->
    @quiz.$el.hide()
    @categories.$el.hide()
    @settings.show(new SettingsView(options: @options, instant: @is_instant()))
    @settings.$el.show()

  show_test_kind_picker: ->
    @settings.$el.show()
    @quiz.$el.hide()
    @categories.$el.hide()
    @tests_kinds.show(new TestKindPickerView())


module.exports =
  View: ManagerView
