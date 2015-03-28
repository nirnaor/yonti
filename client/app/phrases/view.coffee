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
      results: "Test results"
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
AnswerCollection = Backbone.Collection.extend
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
  childView: AnswerView
  childEvents:
    "on_answer_clicked": (ev)->
      console.log "AnswersCollectionView:answer clicked" 
      @triggerMethod "answer_picked", answer: ev.model


QuestionView = Marionette.ItemView.extend
  template: "question"
  className: "table-view-cell"
  tagName: "li"
  ui:
    "question": ".question"
    "guess": ".guess"
  events:
    "click @ui.question": "on_question_clicked"
  on_question_clicked: ->
    console.log "QuestionView: phrase clicked"
    @triggerMethod "single_question_clicked"
  onRender: ->
    guess = @model.get("guess")
    if (typeof(guess) isnt "undefined")
      guess_title = guess.get("answer")
      @ui.guess.html guess_title
    else
      @ui.guess.hide()

  
QuestionsCollectionView = Marionette.CollectionView.extend
  childView: QuestionView
  className: "table-view"
  tagName: "ul"
  childEvents:
    "single_question_clicked": (ev)->
      console.log "PhrasesCollectionView: phrase clicked"
      @triggerMethod "question_clicked", question: ev.model


AnswerResultView = QuestionView.extend
  onRender: ->
    QuestionView.prototype.onRender.apply(@,arguments)
    answer = @model.get "guess"
    if(typeof(answer) is "undefined")
      console.log "no answer"
      @$el.css("background", "yellow")
    else
      if answer.get("answer") == @model.get("correct_answer")
        @$el.css("background", "green")
      else
        @$el.css("background", "red")
   
TestResultView = QuestionsCollectionView.extend
  childView: AnswerResultView

TabsView = Marionette.ItemView.extend
  template: "tabs"
  events:
    "click a.finish":  "on_finish_clicked"
  on_finish_clicked: ->
    @triggerMethod "finish_clicked"

QuizView = Marionette.LayoutView.extend
  template: "layout"
  regions:
    header: ".bar.bar-nav"
    questions: "div.questions"
    answers: "div.answers"
    results: "div.results"
    tabs: "nav.bar.bar-tab"
  childEvents:
    "finish_clicked": (childView, msg)->
      console.log "finish clicked"
      @show_results()
    "question_clicked": (childView, msg)->
      console.log "crap"
      console.log "QuizView: question #{msg.question.get('question')} clicked"
      @selected_question = msg.question
      @swiper.slideNext()
      @show_answers()
    "answer_picked": (childView, msg)->
      console.log "SHIT"
      answer = msg.answer
      console.log "QuizView: answer #{answer.get('answer')} picked
      for #{@selected_question.get('question')}"

      # Unseting first because I wanna make sure that chnage is triggered
      # even if the same answer was picked for the same question
      @selected_question.unset("guess", silent: true)
      @selected_question.set("guess", answer)

      answer.unset("attached_question", silent: true)
      answer.set("attached_question", @selected_question)



  initialize: (options)->

    # Questions realted boilerplate
    @questions = new QuestionCollection()
    @answers = new Backbone.Collection()
    @options.collection.forEach (phrase)=>
      question = new Question({
        question: phrase.get("phrase")
        correct_answer: phrase.get("meaning")
      })
      @questions.add question

      answer = new Answer({answer: phrase.get("meaning")})
      @answers.add answer

    @questions.on("change:guess", (changed_question)=>
      console.log "WILL NOW SHOW THE QUESTIONS VIEW AGAIN"
      @swiper.slidePrev()
      @show_questions()
    )
       


  show_questions: ->
    @showChildView("header", new HeaderView(mode: "questions"))
    @showChildView("questions", new QuestionsCollectionView(collection:
      @questions))
  show_answers: ->
    @showChildView("header", new HeaderView(mode: "answers"))
    @showChildView("answers", new AnswersCollectionView(collection:
      @answers))
  show_results: ->
    result_view = new TestResultView(collection: @questions)
    @showChildView("results", result_view)
    index = result_view.$el.data("slide-index")
    @swiper.slideTo(index)
    @showChildView("header", new HeaderView(
      mode: "results", answers: @answers))
     


  onRender: ->
    @show_answers()
    @show_questions()
    @swiper = new Swiper(".content", {
      direction: 'horizontal'
      loop: true
    })

    @showChildView("tabs", new TabsView())








    


module.exports =
  QuestionView: QuestionView
  PhrasesView: QuestionsCollectionView
  QuizView: QuizView
