Marionette = require "backbone.marionette"


Phrase = require "..//models/phrase"

PhrasesView = Marionette.CollectionView.extend
  render: ->
    @collection.forEach (phrase)=>
      console.log phrase.get("phrase")
      @$el.append(phrase.get("phrase"))
    console.log "will render all the phrases"

module.exports =
  PhrasesViews: PhrasesView
