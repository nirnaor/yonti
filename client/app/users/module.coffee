_ = require "underscore"
$ = require "jquery"
Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"
Requests = require "../lib/requests"
Utils = require "../lib/utils"


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
      ( => @triggerMethod("signed_up_success")),
      ( => @fill_errors(arguments[0].responseJSON))
    )
    


    

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
      ( => @triggerMethod "signed_in_successfully"),
      ( => @on_login_failed())
    )
  on_login_failed: ->
    $("<li>").html("wrong username or password").appendTo(@ui.errors)


SignUpLoginListView = BaseList.ListView.extend
  onRender: ->
    sign_up = new BaseList.ListItemView(text: "Sign up")
    sign_up.on "item_clicked", => @triggerMethod "signup_clicked"
    login = new BaseList.ListItemView(text: "Log In")
    login.on "item_clicked", => @triggerMethod "login_clicked"

    for view in [ sign_up, login ]
      @$el.append(view.render().el)

SignUpLoginView = BaseLayout.extend
  childEvents:
    signup_clicked: "sign_up"
    login_clicked: "login"
    signed_up_success: "login"

  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @content.show(new SignUpLoginListView)
    # @login()

  sign_up: ->
    @set_header "Sign up to add your own tests"
    @content.show(new SignUpView)

  login: ->
    @set_header "Sign in to add your own tests"
    @content.show(new LoginView)


module.exports = SignUpLoginView
