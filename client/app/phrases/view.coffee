$ = require "jquery"
Backbone = require "backbone"
Marionette = require "backbone.marionette"
Phrase = require "./model"


HeaderView = Marionette.ItemView.extend
  template: "header"
  ui:
    "title": ".title"
  onRender: ->
    header = {
      questions: "Pick a phrase"
      answers: "Pick matching definition"
    }[@options.mode]
    @ui.title.html(header)



Question = Backbone.Model.extend({})
QuestionCollection = Backbone.Collection.extend
  initialize: (modles, options)->
    console.log "QuestionCollection initialize"
    @on("change:guess", (changed_question)->
      console.log "QUESTIONCOLLECTION GUESS CHANGES"

      @forEach (question) ->
        if question.cid != changed_question.cid
          guess = question.get("guess")
          if(typeof(guess) != "undefined")
            if guess.get("answer") == changed_question.get("guess").get("answer")
              question.unset("guess", silent: true)
              console.log "Reset duplicate answer"
    )

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

QuizView = Marionette.LayoutView.extend
  template: "layout"
  regions:
    header: ".bar.bar-nav"
    content: "div.content"
  childEvents:
    "question_clicked": (childView, msg)->
      console.log "crap"
      console.log "QuizView: question #{msg.question.get('question')} clicked"
      @selected_question = msg.question
      @showChildView("content",
        new AnswersCollectionView(collection: @answers))
    "meaning_picked": (childView, msg)->
      console.log "SHIT"
      meaning = msg.meaning
      console.log "QuizView: Meaning #{meaning.get('meaning')} picked
      for #{@selected_question.get('phrase')}"
      @selected_question.set("guess", meaning)



  initialize: (options)->

    @header_view = new HeaderView(mode: "answers")

    # Questions realted boilerplate
    @questions = new QuestionCollection()
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
      console.log "WILL NOW SHOW THE QUESTIONS VIEW AGAIN"
      @showChildView("content", new QuestionsCollectionView(
        collection: @questions))
    )
       



    # View events
    @questions_view.on "question_clicked", (ev)=>


  onRender: ->
    @showChildView("header", @header_view)
    @showChildView("content", @questions_view)






    


module.exports =
  QuestionView: QuestionView
  PhrasesView: QuestionsCollectionView
  QuizView: QuizView
