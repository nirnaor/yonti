$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"


Phrase = require "..//models/phrase"

PhrasesView = Marionette.CollectionView.extend
  render: ->
    console.log "will render all the phrases"

module.exports =
  PhrasesViews: PhrasesView
