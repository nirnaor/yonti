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
  public_spreadsheet_url = "https://docs.google.com/spreadsheets/d/1tbNkD6NIozNB4nywTNdNGDhVyFcFlk-arOHG3oTqTho/pubhtml?gid=1987288858&single=true"

  showInfo = (data, tabletop)->
      console.log("Successfully processed!")
      console.log(data)
      app.start(data: data)

  Tabletop.init( key: public_spreadsheet_url,    callback: showInfo,simpleSheet: true)
