_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"

Backbone.Marionette.Renderer.render = (template, data)->
  JST[template](data)

Phrase = require "./phrases/module"
DummyData = require "./dummy_data"




app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new Backbone.Collection()
  _(DummyData.data).forEach (el)=>
    @phrases.add(new Phrase.Model(el))
)

app.on("start", (options)->
  phrases_view = new Phrase.Views.Quiz(
    collection: @phrases
    el: $("div.content")
  ).render()
)

$ ->
  app.start()
