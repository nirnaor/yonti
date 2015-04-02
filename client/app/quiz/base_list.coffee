Marionette = require "backbone.marionette"
Hammer = require "hammerjs"
Gestures = require "../gestures"

ListItemView = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  onRender: ->
    hammer = Gestures.add(@el, "tap", @item_clicked, @)
  item_clicked: (ev)->
    throw new Error("item_clicked should be implemented")

ListView = Marionette.CollectionView.extend
  className: "table-view"
  tagName: "ul"

module.exports =
  ListItemView: ListItemView
  ListView: ListView
