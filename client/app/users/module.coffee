_ = require "underscore"
$ = require "jquery"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"
Requests = require "../lib/requests"
LocalStorage = require "../lib/local_storage"
Utils = require "../lib/utils"
Category = require("../categories/category")


logout = ->
  LocalStorage.remove "user"
current_user = ->
  attributes = LocalStorage.get "user"
  new Backbone.Model(attributes)
is_logged_in = ->
  user = LocalStorage.get "user"
  typeof(user) isnt "undefined"
login_user =  (user_attributes)->
  user = new Backbone.Model(user_attributes)
  LocalStorage.set("user", user)
        
        


SignUpView = Marionette.ItemView.extend
  template: "sign_up"
  ui:
    sign_up: "button"
    form: "form"
    errors: ".errors"
  events:
    "click @ui.sign_up": "on_sign_up"

  fill_errors: (errors)->
    @ui.errors.html ""
    for field, message of errors
      message = "#{field} - #{message}"
      console.log message
      $("<li>").html(message).appendTo(@ui.errors)


  on_sign_up: (ev)->
    ev.preventDefault()

    data = user: Utils.form_data(@ui.form)

    # Validate passwords
    if data.password isnt data.password_confirmation
      return @fill_errors( password: "is not the same as confirmation" )

    # Try to sign up and sign in the server
    Requests.post("users/", data,
      ( => @on_success(arguments[0])),
      ( => @fill_errors(arguments[0].responseJSON))
    )

  on_success: (user_attributes)->
    login_user user_attributes
    @triggerMethod("signed_up_success")


    

LoginView = Marionette.ItemView.extend
  template: "login"
  ui:
    sign_in: "button"
    form: "form"
    errors: ".errors"
  events:
    "click @ui.sign_in": "on_sign_in"
  on_sign_in: (ev)->
    ev.preventDefault()
    console.log "sign in clicked"
    data = Utils.form_data(@ui.form)

    Requests.post("sessions/", data,
      ( => @on_login_success(arguments[0])),
      ( => @on_login_failed())
    )

  on_login_failed: ->
    $("<li>").html("wrong username or password").appendTo(@ui.errors)

  on_login_success:(user_attributes) ->
    login_user user_attributes
    @triggerMethod "login_success"

UsersList = BaseList.ListView.extend

  onRender: ->
    users = _(@options.data).keys()
    for user in users
      user_view = new BaseList.ListItemView(text: user)
      user_view.on "item_clicked", =>
        console.log "yope"
        @show_single_user_tests(user)
      user_view.render().$el.appendTo(@el)

  show_single_user_tests: (user)->
    raw_categories = @options.data[user]
    categories = Category.collection_from_raw(raw_categories)
    @show_categories(categories)

  show_categories: (categories_collection) ->

    # cat = new Category.View(collection: categories_collection)
    # @categories.show(cat)
    view_config =
      view: Category.ListView
      args:
        collection: categories_collection

    console.log "this is manager"
    @triggerMethod "show_config_view", view_config

# UsersListView = BaseLayout.extend
#   childEvents:
#     category_picked: (childView, msg)->
#       console.log "UsersListView category picked"
#       @triggerMethod "category_picked", msg
#     single_user_clicked: (childView, msg)->
#       user = msg.user
#       console.log "single user clicked: #{user}"
#       @show_single_user_tests(user)
#     on_back_clicked: ->
#       console.log "UsersListView on back clicked"
#   show_single_user_tests: (user)->
#     raw_categories = @options.data[user]
#     categories = Category.collection_from_raw(raw_categories)
#     @show_categories(categories)
#   onRender: ->
#     BaseLayout.prototype.onRender.apply(@,arguments)
#     data = @options.data
#     view_config = 
#       view:UsersList,
#       args:
#         data: data
#     @fill_content(view_config)
#     @set_header "Pick a user to see his tests"
#   # back_clicked_no_previous: ->
#   #   console.log "UsersListView on back clicked"
#   show_categories: (categories_collection) ->

#     # cat = new Category.View(collection: categories_collection)
#     # @categories.show(cat)
#     view_config =
#       view: Category.ListView
#       args:
#         collection: categories_collection

#     @fill_content(view_config)
#     console.log "this is manager"

SignUpLoginListView = BaseList.ListView.extend
  onRender: ->
    views = []
    if is_logged_in()
      user = current_user()
      text = "Logged in as #{user.get("name")}"
      logged_in_as = new BaseList.ListItemView(text: text)
      log_out = new BaseList.ListItemView(text: "Log out")
      log_out.on "item_clicked", =>
        logout()
        @triggerMethod "logout_success"
      views = [ logged_in_as, log_out ]
    else
      sign_up = new BaseList.ListItemView(text: "Sign up")
      sign_up.on "item_clicked", => 
        console.log "SignUpLoginView:sign up clicked"
        @triggerMethod "signup_clicked"
      login = new BaseList.ListItemView(text: "Log In")
      login.on "item_clicked", => @triggerMethod "login_clicked"
      views = [ sign_up, login ]

    for view in views
      @$el.append(view.render().el)


SignUpLoginLayout = BaseLayout.extend
  childEvents:
    signup_clicked: ->
      console.log "SignUpLoginView child events"
      @sign_up()
    login_clicked: "login"
    signed_up_success: "on_login_success"
    login_success: "on_login_success"
    logout_success: "onRender"
  back_clicked_no_previous: ->
    console.log "SignUpLoginView back clicked no previous"
    @triggerMethod "back_no_previous"

  on_login_success: ->
    @onRender()
    console.log "Noticed successful login"
    @triggerMethod "login_success"

  onRender: ->
    console.log "User signed in: #{is_logged_in()}"
    BaseLayout.prototype.onRender.apply(@,arguments)
    @fill_content(view:SignUpLoginListView)
    # @login()

  sign_up: ->
    console.log "SignUpLoginView: sign_up"
    @set_header "Sign up to add your own tests"
    @fill_content(view:SignUpView)

  login: ->
    @set_header "Sign in to add your own tests"
    @fill_content(view:LoginView)


module.exports =
  SignUpLoginLayout: SignUpLoginLayout
  # UsersListView: UsersListView
  UsersList: UsersList
  SignUpLoginListView: SignUpLoginListView
  is_logged_in: is_logged_in
  current_user: current_user
