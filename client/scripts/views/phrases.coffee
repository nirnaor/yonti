Marionette = require "backbone.marionette"
Phrase = require "..//models/phrase"

PhraseView = Marionette.ItemView.extend
  template: "phrase"
  
PhraseCollectionView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"

module.exports =
  PhraseView: PhraseView
  PhrasesCollectionView: PhraseCollectionView
