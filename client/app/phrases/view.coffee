$ = require "jquery"
Swiper = require "swiper"
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
      answers: "Find the match"
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
    @triggerMethod "single_question_clicked"
  onRender: ->
    guess = @model.get("guess")
    if (typeof(guess) isnt "undefined")
      bla = guess.get("answer")
      @$el.append("____#{bla}")

  
QuestionsCollectionView = Marionette.CollectionView.extend
  childView: QuestionView
  className: "table-view"
  tagName: "ul"
  childEvents:
    "single_question_clicked": (ev)->
      console.log "PhrasesCollectionView: phrase clicked"
      @triggerMethod "question_clicked", question: ev.model

QuizView = Marionette.LayoutView.extend
  template: "layout"
  regions:
    header: ".bar.bar-nav"
    questions: "div.questions"
    answers: "div.answers"
  childEvents:
    "question_clicked": (childView, msg)->
      console.log "crap"
      console.log "QuizView: question #{msg.question.get('question')} clicked"
      @selected_question = msg.question
      # @showChildView("answers",
      #   new AnswersCollectionView(collection: @answers))
      @showChildView("header", new HeaderView(mode: "answers"))
      @swiper.slideNext()
    "meaning_picked": (childView, msg)->
      console.log "SHIT"
      meaning = msg.meaning
      @showChildView("header", new HeaderView(mode: "questions"))
      console.log "QuizView: Meaning #{meaning.get('meaning')} picked
      for #{@selected_question.get('phrase')}"
      @selected_question.set("guess", meaning)



  initialize: (options)->

    # Questions realted boilerplate
    @questions = new QuestionCollection()
    @options.collection.forEach (phrase)=>
      question = new Question({question: phrase.get("phrase")})
      @questions.add question


    # Answers realted boilerplate
    @answers = new Backbone.Collection()
    @options.collection.forEach (phrase)=>
      answer = new Answer({answer: phrase.get("meaning")})
      @answers.add answer

    @questions.on("change:guess", (changed_question)=>
      console.log "WILL NOW SHOW THE QUESTIONS VIEW AGAIN"
      @swiper.slidePrev()
      @showChildView("questions", new QuestionsCollectionView(
        collection: @questions))
    )
       




  onRender: ->
    @showChildView("header", new HeaderView(mode: "questions"))
    @showChildView("questions", new QuestionsCollectionView(collection:
      @questions))
    @showChildView("answers", new AnswersCollectionView(collection:
      @answers))

    @swiper = new Swiper(".content", {
      direction: 'horizontal'
      loop: true
    })







    


module.exports =
  QuestionView: QuestionView
  PhrasesView: QuestionsCollectionView
  QuizView: QuizView
