Marionette = require "backbone.marionette"

BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"


SignUpView = Marionette.ItemView.extend
  template: "sign_up"

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
