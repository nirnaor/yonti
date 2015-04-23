BaseLayout = require("../base/layout").BaseLayout
BaseList = require "../base/base_list"


TestKindsListView = BaseList.ListView.extend
  onRender: ->
    community_tests = new BaseList.ListItemView(text: "Community tests")
    community_tests.on "item_clicked", => @triggerMethod "community_clicked"
    my_tests = new BaseList.ListItemView(text: "My Tests")

    for view in [ community_tests, my_tests ]
      @$el.append(view.render().el)

TestKindPickerView = BaseLayout.extend
  childEvents:
    community_clicked: -> @triggerMethod "community_clicked"
  onRender: ->
    BaseLayout.prototype.onRender.apply(@,arguments)
    @set_header "Choose type of test"
    @content.show(new TestKindsListView())

module.exports = TestKindPickerView
