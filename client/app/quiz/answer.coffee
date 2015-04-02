_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

Answer = Backbone.Model.extend({})
AnswerCollection = Backbone.Collection.extend
  comparator: (answer)->
    # Using a sample to make the order random
    _([-1,0,1]).sample()
  initialize: (modles, options)->
    console.log "QuestionCollection initialize"
    @on("change:attached_question", (changed_answer)->

      @forEach (answer) ->
        if answer.cid != changed_answer.cid
          attached_question = answer.get("attached_question")
          if(typeof(attached_question) != "undefined")
            if attached_question.get("question") == changed_answer.get("attached_question").get("question")
              answer.unset("attached_question", silent: true)
              console.log "Reset duplicate answer"
    )



AnswerView = Marionette.ItemView.extend
  template: "answer"
  className: "table-view-cell"
  tagName: "li"
  ui:
    "answer": ".answer"
    "attached_question": ".attached_question"
  events:
    "click @ui.answer": "on_answer_clicked"
  on_answer_clicked:->
    console.log "AnswerView: answer clicked"
    @triggerMethod "on_answer_clicked"
  onRender: ->
    question = @model.get("attached_question")
    if (typeof(question) isnt "undefined")
      q_title = question.get("question")
      @ui.attached_question.html q_title
    else
      @ui.attached_question.hide()

      
AnswersCollectionView = Marionette.CollectionView.extend
  className: "table-view"
  tagName: "ul"
  childView: AnswerView
  childEvents:
    "on_answer_clicked": (ev)->
      console.log "AnswersCollectionView:answer clicked" 
      @triggerMethod "answer_picked", answer: ev.model


module.exports =
  Model: Answer
  Collection: AnswerCollection
  Views:
    AnswersCollectionView: AnswersCollectionView
