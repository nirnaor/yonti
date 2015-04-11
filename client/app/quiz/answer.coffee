_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base/base_list"

Answer = Backbone.Model.extend
  same_as: (answer)-> @get("answer") is answer.get("answer")

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

  add: (models, options)->
    models = [ models ] unless _(models).isArray()

    new_models = []

    # Looping on the new models to add
    for model in models
      # If collection doesnt have the same answer already
      same_answer =  @find (existing_answer)->
        model.same_as(existing_answer)
      
      # If we didnt find an answer, add it later
      if typeof(same_answer) is "undefined"
        new_models.push model


    console.log "overriding add"
    Backbone.Collection.prototype.add.call(@,new_models, options)




AnswerView = BaseList.ListItemView.extend
  template: "answer"
  ui:
    "answer": ".answer"
    "attached_question": ".attached_question"
  item_clicked:->
    console.log "AnswerView: answer clicked"
    @triggerMethod "on_answer_clicked"
  onRender: ->
    BaseList.ListItemView.prototype.onRender.apply(@,arguments)
    question = @model.get("attached_question")
    if (typeof(question) isnt "undefined")
      q_title = question.get("question")
      @ui.attached_question.html(q_title.substring(0,10))
    else
      @ui.attached_question.hide()

      
AnswersCollectionView = BaseList.ListView.extend
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
