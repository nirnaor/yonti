_ = require "underscore"
$ = require "jquery"
Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"
Requests = require "../lib/requests"


SignUpView = Marionette.ItemView.extend
  template: "sign_up"
  ui:
    sign_up: "button"
    form: "form"
  events:
    "click @ui.sign_up": "on_sign_up"
  on_sign_up: (ev)->
    ev.preventDefault()

    success = (data,textStatus,jqHXR) ->
      console.log data
      console.log "back from server"
    error = (data,textStatus,jqHXR) ->
      console.log "ERROR"

    data = {}
    for field in @ui.form.serializeArray()
      data[field.name] = field.value
    console.log data

    Requests.post("users/", data, success, error)
    


    

LoginView = Marionette.ItemView.extend
  template: "login"


SingUpLoginListView = BaseList.ListView.extend
  onRender: ->
    sign_up = new BaseList.ListItemView(text: "Sign up")
    sign_up.on "item_clicked", => @triggerMethod "signup_clicked"
    login = new BaseList.ListItemView(text: "Log In")
    login.on "item_clicked", => @triggerMethod "login_clicked"

    for view in [ sign_up, login ]
      @$el.append(view.render().el)

SignUpLoginView = BaseLayout.extend
  childEvents:
    signup_clicked: ->  @content.show(new SignUpView())
    login_clicked: -> @content.show(new LoginView())
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "Sign up to add your own tests"
    @content.show(new SingUpLoginListView())
    # @content.show(new SignUpView())


module.exports = SignUpLoginView
