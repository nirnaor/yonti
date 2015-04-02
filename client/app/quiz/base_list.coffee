Marionette = require "backbone.marionette"
Hammer = require "hammerjs"

ListItemView = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  onRender: ->
    hammer = new Hammer(@el)
    hammer.on "tap", (ev)=>
      console.log "tap detected"
      @item_clicked()
  item_clicked: (ev)->
    throw new Error("item_clicked should be implemented")

ListView = Marionette.CollectionView.extend
  className: "table-view"
  tagName: "ul"

module.exports =
  ListItemView: ListItemView
  ListView: ListView
