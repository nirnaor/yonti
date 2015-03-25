Marionette = require "backbone.marionette"
Phrase = require "./model"

PhraseView = Marionette.ItemView.extend
  template: "phrase"
  
PhrasesView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"

module.exports =
  PhraseView: PhraseView
  PhrasesView: PhrasesView
