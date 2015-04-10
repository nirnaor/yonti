_ = require "underscore"
Marionette = require "backbone.marionette"

Question = require "./question"

AnswerResultView = Question.Views.QuestionView.extend
  template: "result"
  ui:
    "question": ".question"
    "guess": ".guess"
    "correction": ".correction"
    "correction_container": ".correction-container"
    "icon": ".question-icon.icon"
  onRender: ->
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

   
TestResultView = Question.Views.QuestionsCollectionView.extend
  childView: AnswerResultView


module.exports =
  AnswerResultView: AnswerResultView
  TestResultView: TestResultView

