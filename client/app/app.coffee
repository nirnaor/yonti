_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"
QuizView = require "./quiz/quiz"
Question = require "./quiz/question"

Backbone.Marionette.Renderer.render = (template, data)->
  JST[template](data)

DummyData = require "./dummy_data"
Data = require "./data"




app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new Question.Collection()
  _(options.data).forEach (el)=>
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
  data = new Data.Data()
  # data = new DummyData.Data()
  data.on "load_finished",(ev)->
    console.log ev.data
    app.start(data: ev.data)

  data.load()
