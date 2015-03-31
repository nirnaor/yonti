$ = require "jquery"
_ = require "underscore"
Swiper = require "swiper"
Backbone = require "backbone"
Marionette = require "backbone.marionette"
Menu = require "./menu"


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



Question = Backbone.Model.extend
  result: ->
    answer = @get "guess"
    if(typeof(answer) is "undefined")
      return "missing"
    else
      if answer.get("answer") == @get("correct_answer")
        return "correct"
      else
        return "mistake"

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
  categories: ->
    categories = _(@models).map (phrase)->
      phrase.get("category")
    models = _(categories).uniq().map (category)-> category: category
    new Backbone.Collection(models)
  by_category: (category)->
    models =@filter (question)-> question.get('category') is category
    new Backbone.Collection(models)
  summary: ->
    correct = []
    mistake = []
    missing = []
    @forEach (question)->
      switch question.result()
        when "correct" then correct.push question
        when "missing" then missing.push question
        when "mistake" then mistake.push question

    grade = ((100 / @length) * correct.length).toFixed()
    { grade: grade, correct: correct.length, mistake: mistake.length,
    missing: missing.length }


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
    color = {
      missing: "yellow"
      mistake: "red"
      correct: "green"
    }[@model.result()]

    @$el.css("background", color)
   
TestResultView = QuestionsCollectionView.extend
  childView: AnswerResultView

TabsView = Marionette.ItemView.extend
  template: "tabs"
  events:
    "click a.finish":  "on_finish_clicked"
    "click a.restart":  "on_restart_clicked"
  on_finish_clicked: ->
    @triggerMethod "finish_clicked"
  on_restart_clicked: ->
    @triggerMethod "restart_clicked"









    


module.exports =
  QuestionView: QuestionView
  QuestionCollection: QuestionCollection
  QuestionsCollectionView: QuestionsCollectionView
  AnswerCollection: AnswerCollection
  AnswersCollectionView: AnswersCollectionView
  PhrasesView: QuestionsCollectionView
  Question: Question
  Answer: Answer
  HeaderView: HeaderView
  TabsView: TabsView
  TestResultView : TestResultView
