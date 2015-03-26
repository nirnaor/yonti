$ = require "jquery"
Backbone = require "backbone"
Marionette = require "backbone.marionette"
Phrase = require "./model"


Question = Backbone.Model.extend({})
Answer = Backbone.Model.extend({})

AnswerView = Marionette.ItemView.extend
  template: "answer"
  className: "table-view-cell"
  ui:
    "answer": ".answer"
  events:
    "click @ui.answer": "on_answer_clicked"
  on_answer_clicked:->
    console.log "AnswerView: answer clicked"
    @triggerMethod "on_answer_clicked"

      
AnswersCollectionView = Marionette.CollectionView.extend
  className: "table-view"
  childView: AnswerView
  childEvents:
    "on_answer_clicked": (ev)->
      console.log "AnswersCollectionView:answer clicked" 
      @triggerMethod "meaning_picked", meaning: ev.model


QuestionView = Marionette.ItemView.extend
  template: "question"
  className: "table-view-cell"
  ui:
    "question": ".question"
  events:
    "click @ui.question": "on_question_clicked"
  on_question_clicked: ->
    console.log "QuestionView: phrase clicked"
    @triggerMethod "question_clicked"
  onRender: ->
    guess = @model.get("guess")
    if (typeof(guess) isnt "undefined")
      bla = guess.get("answer")
      @$el.append("____#{bla}")

  
QuestionsCollectionView = Marionette.CollectionView.extend
  childView: QuestionView
  template: "phrases"
  className: "table-view"
  tagName: "ul"
  childEvents:
    "question_clicked": (ev)->
      console.log "PhrasesCollectionView: phrase clicked"
      @triggerMethod "question_clicked", question: ev.model

QuizView = Marionette.ItemView.extend
  template: false
  initialize: (options)->

    # Questions realted boilerplate
    @questions = new Backbone.Collection()
    @options.collection.forEach (phrase)=>
      question = new Question({question: phrase.get("phrase")})
      @questions.add question

    @questions_view =  new QuestionsCollectionView(collection: @questions)

    # Answers realted boilerplate
    @answers = new Backbone.Collection()
    @options.collection.forEach (phrase)=>
      answer = new Answer({answer: phrase.get("meaning")})
      @answers.add answer

    @answers_view = new AnswersCollectionView(
      collection: @answers
    )

    @questions.on("change:guess", (changed_question)=>
      console.log "Picked answer for #{changed_question.get('question')}"

      @questions.forEach (question) ->
        if question.cid != changed_question.cid
          guess = question.get("guess")
          if(typeof(guess) != "undefined")
            if guess.get("answer") == changed_question.get("guess").get("answer")
              question.unset("guess", silent: true)
              console.log "Reset duplicate answer"
      @$el.html(@questions_view.render().el)
    )



    # View events
    @questions_view.on "question_clicked", (ev)=>
      console.log "QuizView: question #{ev.question.get('question')} clicked"
      @selected_question = ev.question
      @$el.html(@answers_view.render().el)

    @answers_view.on "meaning_picked", (ev)=>
      meaning = ev.meaning
      console.log "QuizView: Meaning #{meaning.get('meaning')} picked
      for #{@selected_question.get('phrase')}"
      @selected_question.set("guess", meaning)

  onRender: ->
    @$el.html(@questions_view.render().el)






    


module.exports =
  QuestionView: QuestionView
  PhrasesView: QuestionsCollectionView
  QuizView: QuizView
