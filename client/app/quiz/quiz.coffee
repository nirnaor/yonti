$ = require "jquery"
_ = require "underscore"
Swiper = require "swiper"
Answer = require "./answer"
Backbone = require "backbone"
Marionette = require "backbone.marionette"
Category = require "./category"
Question = require "./question"
TabsView = Question.TabsView
Result = require "./result"


TabsView = Marionette.ItemView.extend
  template: "tabs"
  events:
    "click a.finish":  "on_finish_clicked"
    "click a.restart":  "on_restart_clicked"
  on_finish_clicked: ->
    @triggerMethod "finish_clicked"
  on_restart_clicked: ->
    @triggerMethod "restart_clicked"

HeaderView = Marionette.ItemView.extend
  template: "header"
  ui:
    "title": ".title"
    "show_menu": ".icon-list"
  events:
    "click @ui.show_menu": "on_show_menu_clicked"
  on_show_menu_clicked: ->
    @triggerMethod "show_menu_clicked"
  onRender: ->
    header = {
      questions: "Pick a phrase"
      answers: "Find the match"
      results: "Grade: #{@options.grade}"
    }[@options.mode]
    @ui.title.html(header)








QuizView = Marionette.LayoutView.extend
  template: "layout"
  regions:
    header: ".bar.bar-nav"
    questions: "div.questions"
    answers: "div.answers"
    menu: "div.menu"
    results: "div.results"
    tabs: "nav.bar.bar-tab"
  childEvents:
    "show_menu_clicked": (childView, msg)->
      console.log "show menu clicked"
      @show_menu()
    "finish_clicked": (childView, msg)->
      console.log "finish clicked"
      @show_results()
    "restart_clicked": (childView, msg)->
      console.log "restart clicked"
      @init_quiz()
      @show_questions()
    "question_clicked": (childView, msg)->
      console.log "crap"
      console.log "QuizView: question #{msg.question.get('question')} clicked"
      @selected_question = msg.question
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
    @init_quiz()
  init_quiz: (options)->

    # Questions realted boilerplate
    @questions = new Question.Collection()
    @answers = new Answer.Collection()
    @options.collection.forEach (phrase)=>
      question = new Question.Model({
        question: phrase.get("phrase")
        correct_answer: phrase.get("meaning")
        category: phrase.get("category")
      })
      @questions.add question

      answer = new Question.Model({answer: phrase.get("meaning")})
      @answers.add answer

    @questions.on("change:guess", (changed_question)=>
      console.log "WILL NOW SHOW THE QUESTIONS VIEW AGAIN"
      @show_questions()
    )
       


  show_questions: ->
    @showChildView("header", new HeaderView(mode: "questions"))
    @showChildView("questions", new Question.Views.QuestionsCollectionView(collection:
      @questions))
    @swiper.slideTo(0)
  show_answers: ->
    @showChildView("header", new HeaderView(mode: "answers"))
    @showChildView("answers", new Answer.Views.AnswersCollectionView(collection:
      @answers))
    @swiper.slideTo(1)
  show_results: ->
    result_view = new Result.TestResultView(collection: @questions)
    @showChildView("results", result_view)
    @swiper.slideTo(2)
    @showChildView("header", new HeaderView(
      mode: "results", grade: @questions.summary().grade))
  show_menu: ->
    @showChildView("header", new HeaderView(mode: "pick_test"))
    @showChildView("menu", new Category.View(questions:
      @questions))
    @swiper.slideTo(3)


  onRender: ->
    @swiper = new Swiper(".content", {
      direction: 'horizontal'
    })

    @show_questions()
    @showChildView("tabs", new TabsView())
module.exports =
  QuizView: QuizView
