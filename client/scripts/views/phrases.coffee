Marionette = require "backbone.marionette"


Phrase = require "..//models/phrase"

PhrasesView = Marionette.ItemView.extend
  template: "phrases"

module.exports =
  PhrasesViews: PhrasesView
