Marionette = require "backbone.marionette"
Phrase = require "./model"

PhraseView = Marionette.ItemView.extend
  template: "phrase"
  className: "table-view-cell"
  
PhrasesView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"
  className: "table-view"
  tagName: "ul"

module.exports =
  PhraseView: PhraseView
  PhrasesView: PhrasesView
