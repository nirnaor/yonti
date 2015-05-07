BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"


HomeListView = BaseList.ListView.extend
  onRender: ->
    community_tests = new BaseList.ListItemView(text: "Tests")
    community_tests.on "item_clicked", => @triggerMethod "community_clicked"
    my_tests = new BaseList.ListItemView(text: "My Tests")
    my_tests.on "item_clicked", => 
      console.log "HomeView my  test clicked"
      @triggerMethod "my_tests_clicked"

    edit_tests = new BaseList.ListItemView(text: "Edit my tests")
    edit_tests.on "item_clicked", => @triggerMethod "edit_my_tests_clicked"

    users = new BaseList.ListItemView(text: "Users")
    users.on "item_clicked", => @triggerMethod "users_clicked"

    for view in [ community_tests,  users, my_tests, edit_tests]
      @$el.append(view.render().el)

HomePickerView = BaseLayout.extend
  childEvents:
    community_clicked: -> @triggerMethod "community_clicked"
    my_tests_clicked: -> @triggerMethod "my_tests_clicked"
    users_clicked: -> @triggerMethod "users_clicked"
    edit_my_tests_clicked: -> @triggerMethod "edit_my_tests_clicked"
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "Choose type of test"
    @content.show(new HomeListView())
  on_show_settings_clicked: ->
    @triggerMethod "show_settings_clicked"


module.exports = HomeListView
