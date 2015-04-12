Marionette = require "backbone.marionette"

CategoryView = require("../categories/category").View
QuizView = require("../quiz/quiz").QuizView
SettingsView = require("../settings/list").View

ManagerView = Marionette.LayoutView.extend
  template: "manager_layout"

  regions:
    "categories": ".categories"
    "quiz": ".quiz"
    "settings": ".settings"

  childEvents:
    "category_picked": (childView, msg)->
      console.log "category #{msg.category} picked"
      @show_quiz(msg.category)
    "show_categories_clicked": (childView, msg)->
      @show_categories()
    "show_settings_clicked": (childView, msg)->
      @show_settings()

  onRender: -> @show_categories()
  # onRender: -> @show_quiz("medicine 2")

  show_categories: ->
    @quiz.$el.hide()
    @categories.show(new CategoryView(collection: @options.collection))
    @categories.$el.show()
    console.log "this is manager"

  show_quiz: (category)->
    @categories.$el.hide()
    questions = @options.collection.by_category(category)
    @categories.reset()
    @quiz.show(new QuizView(collection: questions, category: category))
    @quiz.$el.show()

  show_settings: ->
    # @quiz.$el.hide()
    # @categories.$el.hide()
    @quiz.$el.hide()
    @settings.show(new SettingsView())

module.exports =
  View: ManagerView
