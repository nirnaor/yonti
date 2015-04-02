Marionette = require "backbone.marionette"

ListItemView = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"

ListView = Marionette.CollectionView.extend
  className: "table-view"
  tagName: "ul"

module.exports =
  ListItemView: ListItemView
  ListView: ListView
