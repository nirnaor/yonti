_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"
PhraseViews = require "./quiz/view"
QuizView = require "./quiz/quiz"

Backbone.Marionette.Renderer.render = (template, data)->
  JST[template](data)

DummyData = require "./dummy_data"




app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new PhraseViews.Question.Collection()
  _(DummyData.data).forEach (el)=>
    @phrases.add(new Backbone.Model(el))
)

app.on("start", (options)->
  phrases_view = new QuizView.QuizView(
    category: "sport"
    collection: @phrases
    el: $("body")
  ).render()
)

$ ->
  app.start()
