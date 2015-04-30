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
Utils = require "./lib/utils"




window.app = new Marionette.Application()

app.user_logged_in = -> false

app.on("before:start", (options)->

  # Add theme css based on OS (Only android or ios)
  theme = Utils.os()
  return if theme is 'unknown'
  url = "files/bower_components/ratchet/dist/css/ratchet-theme-#{theme}.css"
  theme_css = $("<link>").attr("rel", "stylesheet").attr("type", "text/css").attr("href", url)
  theme_css.appendTo("head")
)

app.on("start", (options)->

  data = options.data
  models = _(data).map (el)=> new Backbone.Model(el)
  collection = new Question.Collection(models)

  phrases_view = new ManagerView(
    collection: collection
    el: $("body")
    data_manager: options.data_manager
  ).render()
)

$ ->
  data = new DataManager.DataManager()
  # data = new DummyData.Data()
  data.on "load_finished",(ev)->
    console.log "NOTICED ON APP THAT LOAD HAS FINISHED"
    app.start(data: ev.data, data_manager: data)

  data.load()
