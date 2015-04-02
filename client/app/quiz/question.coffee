_ = require "underscore"
Backbone = require "backbone"
Marionette = require "backbone.marionette"

BaseList = require "./base_list"

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

QuestionView = BaseList.ListItemView.extend
  template: "question"
  ui:
    "question": ".question"
    "guess": ".guess"
  item_clicked: ->
    console.log "QuestionView: phrase clicked"
    @triggerMethod "single_question_clicked"
  onRender: ->
    BaseList.ListItemView.prototype.onRender.apply(@,arguments)
    guess = @model.get("guess")
    if (typeof(guess) isnt "undefined")
      guess_title = guess.get("answer")
      @ui.guess.html guess_title
    else
      @ui.guess.hide()

  
QuestionsCollectionView = BaseList.ListView.extend
  childView: QuestionView
  childEvents:
    "single_question_clicked": (ev)->
      console.log "PhrasesCollectionView: phrase clicked"
      @triggerMethod "question_clicked", question: ev.model



module.exports =
  Model: Question
  Collection: QuestionCollection
  Views:
    QuestionView: QuestionView
    QuestionsCollectionView: QuestionsCollectionView
