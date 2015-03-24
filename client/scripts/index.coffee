_ = require "underscore"
$ = require "jquery"
Backbone = require "backbone"

Phrase = require "./models/phrase"
PhrasesViews = require "./views/phrases"

DummyData = require "./dummy_data"


phrases = new Backbone.Collection()
_(DummyData.data).forEach (el)->
  phrases.add(new Phrase(el))

$ ->
  phrases_view = new PhrasesViews.PhrasesViews(
    el: $("div.main")
    collection: phrases
  )
  phrases_view.render()
phrase = new Phrase()
phrase.set("first", "gil")
console.log phrase.get "first"
