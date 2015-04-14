_ = require "underscore"
Marionette = require "backbone.marionette"

Gestures = require "../lib/gestures"

BaseList = require("../base/base_list")

AnswerResultView = BaseList.ListItemView.extend
  template: "result"
  ui:
    "question": ".question"
    "guess": ".guess"
    "correction": ".correction"
    "correction_container": ".correction-container"
    "icon": ".question-icon.icon"
    "google": "a.google"
  onRender: ->
    @bind_google()
    result = @model.result()
    color = {
      missing: "yellow"
      mistake: "red"
      correct: "green"
    }[result]

    # @ui.guess.css("background", color)
    @ui.correction.html(@model.get("correct_answer"))

    guess = @model.get("guess")
    if guess
      @ui.guess.html(guess.get("answer"))

    if result is "correct"
      @ui.correction_container.hide()
      @ui.icon.addClass "icon-check"
    else
      @ui.icon.addClass "icon-close"

  bind_google: ->
    search = @model.get "question"
    @ui.google.attr("href", href="http://google.com/search?q=#{search}")

   
TestResultView = BaseList.ListView.extend
  childView: AnswerResultView


module.exports =
  AnswerResultView: AnswerResultView
  TestResultView: TestResultView

