_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"

Phrase = require "./models/phrase"
PhrasesViews = require "./views/phrases"

DummyData = require "./dummy_data"


Backbone.Marionette.Renderer.render = (template, data)->
  JST[template](data)


app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new Backbone.Collection()
  _(DummyData.data).forEach (el)=>
    @phrases.add(new Phrase(el))
)

app.on("start", (options)->
  phrases_view = new PhrasesViews.PhrasesCollectionView(
    collection: @phrases
    el: $("div.content")
  )
  phrases_view.render()
)

$ ->
  app.start()
