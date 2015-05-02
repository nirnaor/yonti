Backbone = require "backbone"
_ = require "underscore"
Marionette = require "backbone.marionette"

Category = require("../categories/category")
CategoryView = require("../categories/category").View
Categories = require("../categories/category").Collection
QuizView = require("../quiz/quiz").QuizView
Question = require("../quiz/question")
Category = require("../categories/category")
SettingsView = require("../settings/list").View
GooglePhrasesView = require("../settings/list").GooglePhrasesView
Users = require("../users/module")
LocalStorage = require "../lib/local_storage"

SignUpLoginView = require("../users/module").SignUpLoginView


HomeView = require "./home"

ManagerView = Marionette.LayoutView.extend
  initialize: (options)->
    @data = options.data
  template: "manager_layout"

  regions:
    main: ".main"
    # "tests_kinds": ".tests_kinds"
    # "categories": ".categories"
    # "quiz": ".quiz"
    # "settings": ".settings"
    # "users": ".users"
    # "blat": ".blat"

  childEvents:
    login_success: (childView, msg)->
      console.log "login success"
      @show_edit_tests()
    edit_my_tests_clicked: (childView, msg)->
      console.log "edit my tests clicked"
      if app.user_logged_in()
        @show_edit_tests()
      else
        @show_sign_up()
    single_user_clicked: (childView, msg)->
      user = msg.user
      console.log "single user clicked: #{user}"
      @show_single_user_tests(user)

    "category_back_clicked": ->
      @show_test_kind_picker()
    "users_clicked": ->
      console.log "users clicked"
      @show_users()
    "community_clicked": (childView, msg)->

      all_categories = _(@data).map (user_categories, user_name, list)->
        Category.collection_from_raw(user_categories)

      # Concat all collections to one collection
      result_categories = new Backbone.Collection()
      for categories in all_categories
        result_categories.add(categories.models)

      @show_categories(result_categories)

    "my_tests_clicked": (childView, msg)->
      console.log "my tests clicked"
      if app.user_logged_in()
        user = app.current_user().get("name")
        @show_single_user_tests user

    "category_picked": (childView, msg)->
      console.log "category #{msg.category} picked"
      @show_quiz(msg.category)
    "show_home_clicked": (childView, msg)->
      @show_test_kind_picker()
    "show_settings_clicked": (childView, msg)->
      console.log "will show settings"
      @show_settings()

  show_single_user_tests: (user)->
    raw_categories = @data[user]
    categories = Category.collection_from_raw(raw_categories)
    @show_categories(categories)

  is_instant: ->
    instant = LocalStorage.get("instant_mode")
    if typeof(instant) is "undefined"
      instant = true
    instant

  onRender: -> 
    if app.user_logged_in() is true
      @show_test_kind_picker()
    else
      @show_categories()

  # onRender: -> @show_quiz("medicine 2")
  # onRender: -> @show_settings()

  _hide_all: ->
    for region_name, region of @getRegions()
      unless region.$el? 
       resion.$el.hide()

  show_categories: (categories_collection) ->
    @_hide_all()

    cat = new CategoryView(collection: categories_collection)
    # @categories.show(cat)
    @main.show cat
    console.log "this is manager"

  show_quiz: (category)->
    @_hide_all()
    questions = category.get("questions")
    quiz_view = new QuizView(collection: questions, category: category, instant: @is_instant())

    @main.show(quiz_view)

  show_settings: ->
    @main.show(new SettingsView(options: @options, instant: @is_instant()))

  show_test_kind_picker: ->
    @main.show(new HomeView())

  show_sign_up: ->
    @main.show(new SignUpLoginView())

  show_users: ->
    users = _(@data).keys()
    @main.show(new Users.UsersListView(users: users))

  show_edit_tests: ->
    google_url = app.current_user().get("google_url")
    model = new Backbone.Model(url: google_url)
    @main.show(new GooglePhrasesView(model: model))

module.exports =
  View: ManagerView
