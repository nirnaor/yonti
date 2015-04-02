Marionette = require "backbone.marionette"

ListItemView = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  onRender: ->
    @$el.click =>
      console.log "ListItemView click"
      @item_clicked()
  item_clicked: (ev)->
    throw new Error("item_clicked should be implemented")

ListView = Marionette.CollectionView.extend
  className: "table-view"
  tagName: "ul"

module.exports =
  ListItemView: ListItemView
  ListView: ListView
