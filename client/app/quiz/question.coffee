_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "../base/base_list"
AnswerResultView = require("./result").AnswerResultView
LocalStorage = require "../lib/local_storage"

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
              # question.unset("guess", silent: true)
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

QuestionView = BaseList.ListItemView.extend
  template: "question"
  className: "table-view-cell media"
  ui:
    "question": ".question"
    "guess": ".guess"
  onRender: ->
    BaseList.ListItemView.prototype.onRender.apply(@,arguments)
    guess = @model.get("guess")
    if (typeof(guess) isnt "undefined")
      guess_title = guess.get("answer")
      @ui.guess.html guess_title
    else
      @ui.guess.hide()

InstantQuestionView = QuestionView.extend

  onRender: ->
    console.log "InstantQuestionView: Will check if an answer is here"
    QuestionView.prototype.onRender.apply(@,arguments)
    question = @model.get("guess")
    @render_result() if (typeof(question) isnt "undefined")

  render_result: ->
    result_view = new AnswerResultView(model: @model).render()
    result_view.on("body_clicked", @show_message)
    @$el.html result_view.el
    @setElement result_view.el

  show_message: ->
    message = "Oh, Eta Pali. In instant mode you can't repick your answer. " +
      "if you want, you can turn it off in settings"
    alert message

  
QuestionsCollectionView = BaseList.ListView.extend
  getChildView: ->
    return @child_view if @child_view?
    instant = LocalStorage.get("instant_mode")
    if typeof(instant) is "undefined"
      instant = true

    if instant
      result = InstantQuestionView
    else
      result = QuestionView
    @child_view = result
    @child_view

  childEvents:
    "item_clicked": (ev)->
      console.log "PhrasesCollectionView: phrase clicked"
      @triggerMethod "question_clicked", question: ev.model



module.exports =
  Model: Question
  Collection: QuestionCollection
  Views:
    QuestionView: QuestionView
    QuestionsCollectionView: QuestionsCollectionView
