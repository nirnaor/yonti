Marionette = require "backbone.marionette"
Hammer = require "hammerjs"
Gestures = require "../lib/gestures"

ListItemView = Marionette.ItemView.extend
  template: false
  className: "table-view-cell"
  tagName: "li"
  onRender: ->
    if @options.text?
      @$el.html @options.text
    hammer = Gestures.add(@el, "tap", @item_clicked, @)
  item_clicked: (ev)->
    @triggerMethod "item_clicked"

ListView = Marionette.CollectionView.extend
  className: "table-view"
  tagName: "ul"

module.exports =
  ListItemView: ListItemView
  ListView: ListView
