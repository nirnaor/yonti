_ = require "underscore"

$ = require "jquery"
Backbone = require "backbone"
Backbone.$ = $
Marionette = require "backbone.marionette"
QuizView = require "./quiz/quiz"
ManagerView = require("./manager/manager").View
Question = require "./quiz/question"

Backbone.Marionette.Renderer.render = (template, data)->
  tmp = JST[template]
  if typeof(tmp) is "undefined"
    throw new Error "Couldn't find template with name #{template}"
  tmp(data)

DataManager = require "./lib/data_manager"




app = new Marionette.Application()

app.on("before:start", (options)->
  @phrases = new Question.Collection()
  _(options.data).forEach (el)=>
    @phrases.add(new Backbone.Model(el))
)

app.on("start", (options)->
  # phrases_view = new QuizView.QuizView(
  #   category: "sport"
  #   collection: @phrases
  #   el: $("body")
  # ).render()
  phrases_view = new ManagerView(
    collection: @phrases
    el: $("body")
  ).render()
)

$ ->
  data = new DataManager.DataManager()
  # data = new DummyData.Data()
  data.on "load_finished",(ev)->
    console.log "NOTICED ON APP THAT LOAD HAS FINISHED"
    console.log ev.data
    app.start(data: ev.data)

  data.load()
