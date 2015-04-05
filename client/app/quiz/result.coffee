_ = require "underscore"
Marionette = require "backbone.marionette"

Question = require "./question"

AnswerResultView = Question.Views.QuestionView.extend
  template: "result"
  ui:
    "question": ".question"
    "guess": ".guess"
    "correction": ".correction"
  onRender: ->
    result = @model.result()
    color = {
      missing: "yellow"
      mistake: "red"
      correct: "green"
    }[result]

    @ui.guess.css("background", color)
    @ui.correction.html(@model.get("correct_answer"))

    guess = @model.get("guess")
    if guess
      @ui.guess.html(guess.get("answer"))
    else
      @ui.guess.html("missing")

    if result is "correct"
      @ui.correction.hide()

   
TestResultView = Question.Views.QuestionsCollectionView.extend
  childView: AnswerResultView


module.exports =
  AnswerResultView: AnswerResultView
  TestResultView: TestResultView

