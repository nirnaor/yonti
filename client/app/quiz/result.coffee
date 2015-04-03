Marionette = require "backbone.marionette"

Question = require "./question"

AnswerResultView = Question.Views.QuestionView.extend
  template: "result"
  onRender: ->
    Question.Views.QuestionView.prototype.onRender.apply(@,arguments)
    color = {
      missing: "yellow"
      mistake: "red"
      correct: "green"
    }[@model.result()]

    @$el.css("background", color)
   
TestResultView = Question.Views.QuestionsCollectionView.extend
  childView: AnswerResultView


module.exports =
  AnswerResultView: AnswerResultView
  TestResultView: TestResultView

