_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"
PhraseViews = require "./phrases/view"

Backbone.Marionette.Renderer.render = (template, data)->
  JST[template](data)

DummyData = require "./dummy_data"




app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new PhraseViews.QuestionCollection()
  _(DummyData.data).forEach (el)=>
    @phrases.add(new Backbone.Model(el))
)

app.on("start", (options)->
  phrases_view = new PhraseViews.QuizView(
    collection: @phrases.by_category("sport")
    el: $("body")
  ).render()
)

$ ->
  app.start()
