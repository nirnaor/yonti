_ = require "underscore"
$ = require "jquery"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"
Requests = require "../lib/requests"
LocalStorage = require "../lib/local_storage"
Utils = require "../lib/utils"


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
    for user in @options.users
      user_view = new BaseList.ListItemView(text: user)
      user_view.on "item_clicked", =>
        @triggerMethod "single_user_clicked", user: user
      @$el.append(user_view.render().el)


UsersListView = BaseLayout.extend
  childEvents:
    single_user_clicked: (childView, msg)->
      console.log "YO!"
      @triggerMethod "single_user_clicked", msg
  onRender: ->
    @content.show(new UsersList(users: @options.users))
    @set_header "Pick a user to see his tests"

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
      sign_up.on "item_clicked", => @triggerMethod "signup_clicked"
      login = new BaseList.ListItemView(text: "Log In")
      login.on "item_clicked", => @triggerMethod "login_clicked"
      views = [ sign_up, login ]

    for view in views
      @$el.append(view.render().el)

SignUpLoginView = BaseLayout.extend
  childEvents:
    signup_clicked: "sign_up"
    login_clicked: "login"
    signed_up_success: "on_login_success"
    login_success: "on_login_success"
    logout_success: "onRender"

  on_login_success: ->
    @onRender()
    console.log "Noticed successful login"
    @triggerMethod "login_success"

  onRender: ->
    console.log "User signed in: #{is_logged_in()}"
    BaseLayout.prototype.onRender.apply(@,arguments)
    @content.show(new SignUpLoginListView)
    # @login()

  sign_up: ->
    @set_header "Sign up to add your own tests"
    @content.show(new SignUpView)

  login: ->
    @set_header "Sign in to add your own tests"
    @content.show(new LoginView)


module.exports =
  SignUpLoginView: SignUpLoginView
  UsersListView: UsersListView
  is_logged_in: is_logged_in
  current_user: current_user
