Backbone = require "backbone"
_ = require "underscore"
Marionette = require "backbone.marionette"

Category = require("../categories/category")
CategoryView = require("../categories/category").ListView
QuizView = require("../quiz/quiz").QuizView
Question = require("../quiz/question")
Category = require("../categories/category")
SettingsView = require("../settings/list").SettingsView
GoogleView = require("../settings/list").GooglePhrasesView
Users = require("../users/module")
BaseLayout = require("../base/layout").BaseLayout
LocalStorage = require "../lib/local_storage"



HomeView = require "./home"

ManagerView = BaseLayout.extend
  initialize: (options)->
    @data = options.data
    app.vent.on "no_back_implemented", =>
      console.log "Manager: No back is implemented so I must show myself"
      @bla.$el.hide()
      @settings.$el.hide()
      @header.$el.show()
      @content.$el.show()
      @show_test_kind_picker()
      # @onRender()

  # regions:
  #   content: ".content"
  #   bla: ".bla"
    # "tests_kinds": ".tests_kinds"
    # "categories": ".categories"
    # "quiz": ".quiz"
    # "settings": ".settings"
    # "users": ".users"
    # "blat": ".blat"

  childEvents:
    show_config_view: (childView, msg)->
      console.log "Manager:show config view"
      @fill_content msg
    back_no_previous: -> 
      console.log "Manager: Back no previous"
      @onRender()
    login_success: (childView, msg)->
      console.log "login success"
      @show_edit_tests()
    edit_my_tests_clicked: (childView, msg)->
      console.log "edit my tests clicked"
      if app.user_logged_in()
        @show_edit_tests()
      else
        @show_sign_up()
    # "category_back_clicked": ->
    #   @show_test_kind_picker()
    "users_clicked": ->
      console.log "users clicked"
      @show_users()
    "community_clicked": (childView, msg)->
      @show_all_tests()

    "my_tests_clicked": (childView, msg)->
      console.log "my tests clicked"
      if app.user_logged_in()
        user = app.current_user().get("name")
        @show_single_user_tests user
      else
        @show_sign_up()

    "category_picked": (childView, msg)->
      console.log "category #{msg.category} picked"
      @show_quiz(msg.category)
    "show_home_clicked": (childView, msg)->
      console.log "need to show home"
      @show_test_kind_picker()
    "show_settings_clicked": (childView, msg)->
      console.log "will show settings"
      @show_settings()

  show_all_tests: ->
    all_categories = _(@data).map (user_categories, user_name, list)->
      Category.collection_from_raw(user_categories)

    # Concat all collections to one collection
    result_categories = new Backbone.Collection()
    for categories in all_categories
      result_categories.add(categories.models)

    @show_categories(result_categories)

  back_clicked_no_previous: ->
    console.log "ManagerView back_clicked_no_previous"
    @show_test_kind_picker()

  show_sign_up: ->
    @show_settings(true)

  is_instant: ->
    instant = LocalStorage.get("instant_mode")
    if typeof(instant) is "undefined"
      instant = true
    instant

  onRender: -> 
    BaseLayout.prototype.onRender.apply(@,arguments)
    if app.user_logged_in() is true
      @show_test_kind_picker()
    else
      @show_all_tests()

  # onRender: -> @show_quiz("medicine 2")
  # onRender: -> @show_settings()


  show_single_user_tests: (user)->
    raw_categories = @data[user]
    categories = Category.collection_from_raw(raw_categories)
    @show_categories(categories)

  show_categories: (categories_collection) ->
    console.log "ManagerView show categories"
    # @categories.show(cat)
    @set_header "What do you want to learn"
    @fill_content(view: CategoryView, args: {collection: categories_collection})
    console.log "this is manager"

  show_quiz: (category)->
    # @content.$el.hide()
    # @set_header "quiz view man"
    questions = category.get("questions")

    args = collection: questions, category: category, instant: @is_instant()
    # config =
    #   view:QuizView
    #   args: args
        

    # # @fill_content(config)
    quiz_view = new QuizView(args)
    # # @bla.show(quiz_view)

    # When showing the quiz I can't switch the content because
    # it has a bar-footer class that cannot be nested under the content

    @header.$el.hide()
    @content.$el.hide()
    @bla.show(quiz_view)

  show_settings:(show_login_on_render=false) ->
    @content.$el.hide()
    @bla.$el.hide()
    @header.$el.hide()
    console.log "ManagerView show_settings"
    args = options: @options, instant: @is_instant(),
    show_login_on_render: show_login_on_render
    view_config =
      view: SettingsView
      args: args

    @settings.show(new SettingsView(args))

  show_test_kind_picker: ->
    @fill_content(view:HomeView)


  show_users: ->
    # users = _(@data).keys()
    data = @data
    config =
      view: Users.UsersList
      args:
        data: data
    @fill_content(config)

  show_edit_tests: ->
    google_url = app.current_user().get("google_url")
    model = new Backbone.Model(url: google_url)
    view_config = 
      view: GoogleView
      args:
        model: model

    @fill_content(view_config)

module.exports =
  View: ManagerView
