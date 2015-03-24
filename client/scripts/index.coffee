_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"

Phrase = require "./models/phrase"
PhrasesViews = require "./views/phrases"

DummyData = require "./dummy_data"




app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new Backbone.Collection()
  _(DummyData.data).forEach (el)=>
    @phrases.add(new Phrase(el))
)

app.on("start", (options)->
  phrases_view = new PhrasesViews.PhrasesViews(
    el: $("div.main")
    collection: app.phrases
  )
  phrases_view.render()
)

$ ->
  app.start()
