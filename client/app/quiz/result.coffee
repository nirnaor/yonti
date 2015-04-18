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
    "body": ".media-body"
  onRender: ->
    @bind_google()
    result = @model.result()
    @ui.correction.html(@model.get("correct_answer"))

    guess = @model.get("guess")
    if guess
      @ui.guess.html(guess.get("answer"))

    icon_class =
      { correct: "check", mistake: "close", missing: "close" }[result]
    @ui.icon.addClass "icon-#{icon_class}"
    if result is "correct"
      @ui.correction_container.hide()

    Gestures.add(@ui.body.get(0), "tap", @on_body_clicked, @)

  on_body_clicked: -> @triggerMethod "body_clicked"

  bind_google: ->
    search = @model.get "question"
    @ui.google.attr("href", href="http://google.com/search?q=#{search}")

   
TestResultView = BaseList.ListView.extend
  childView: AnswerResultView


module.exports =
  AnswerResultView: AnswerResultView
  TestResultView: TestResultView

