$ = require "jquery"
_ = require "underscore"
Answer = require "./answer"
Backbone = require "backbone"
Marionette = require "backbone.marionette"
Gestures = require "./../lib/gestures"
Slide = require "../lib/slide"
Question = require "./question"
TabsView = Question.TabsView
Result = require "./result"
BaseLayout = require("../base/layout").BaseLayout


TabsView = Marionette.ItemView.extend
  template: "tabs"
  ui:
    finish: "a.finish"
    restart: "a.restart"
    show_menu: ".icon-home"
  onRender: ->
    Gestures.add(@ui.finish.get(0), "tap", @on_finish_clicked, @)
    Gestures.add(@ui.restart.get(0), "tap", @on_restart_clicked, @)
    Gestures.add(@ui.show_menu.get(0), "tap", @on_show_menu_clicked, @)
  on_finish_clicked: ->
    @triggerMethod "finish_clicked"
  on_restart_clicked: ->
    @triggerMethod "restart_clicked"
  on_show_menu_clicked: ->
    @triggerMethod "show_menu_clicked"



QuizView = BaseLayout.extend
  template: "layout"
  regions:
    quiz_content: ".quiz_content"
    tabs: "nav.bar.bar-footer"
  childEvents:
    "show_menu_clicked": (childView, msg)->
      app.vent.trigger "no_back_implemented"
      # @triggerMethod "show_home_clicked"
    "show_settings_clicked": (childView, msg)->
      @triggerMethod "show_settings_clicked"
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
    "category_picked": (childView, msg)->
      console.log "QuizView category picked"
      @options.category = msg.category
      @init_quiz()
      @show_questions()



  initialize: (options)->
    @init_quiz()
  init_quiz: (options)->
    # Questions realted boilerplate
    @questions = new Question.Collection()
    @answers = new Answer.Collection()
    questions = @options.category.get("questions")
    questions.forEach (phrase)=>
      question = new Question.Model({
        question: phrase.get("question")
        correct_answer: phrase.get("answer")
      })
      @questions.add question

      answer = new Answer.Model({answer: phrase.get("answer")})
      @answers.add answer

    @questions.on("change:guess", (changed_question)=>
      console.log "WILL NOW SHOW THE QUESTIONS VIEW AGAIN"
      @show_questions()
    )
       


  show_questions: ->
    if @options.instant
      @show_results_header()
    else
      @set_header "Pick a phrase"
    questions_view = new Question.Views.QuestionsCollectionView(
      collection: @questions, instant: @options.instant)
     
    @showChildView("quiz_content", questions_view)
    
    @slide.to(0)
  show_answers: (name)->
    @set_header @selected_question.get("question")
    @showChildView("quiz_content", new Answer.Views.AnswersCollectionView(collection:
      @answers))
    @slide.to(1)
  show_results: ->
    result_view = new Result.TestResultView(collection: @questions)
    @showChildView("quiz_content", result_view)
    @slide.to(2)
    @show_results_header()
  show_results_header: ->
    @set_header "grade: #{@questions.summary().grade}" 


  onRender: ->
    @slide = new Slide.Slide(".quiz_content")
    @show_questions()
    @showChildView("tabs", new TabsView())
module.exports =
  QuizView: QuizView
