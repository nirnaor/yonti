Marionette = require "backbone.marionette"

MenuItem = Marionette.ItemView.extend
  className: "table-view-cell"
  tagName: "li"
  template: "menu"


MenuView = Marionette.CollectionView.extend
  childView: MenuItem
  template: false
  className: "table-view"
  tagName: "ul"
  
 module.exports =
   MenuView: MenuView
  
