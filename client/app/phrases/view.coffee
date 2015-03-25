$ = require "jquery"
Marionette = require "backbone.marionette"
Phrase = require "./model"

MeaningView = Marionette.ItemView.extend
  template: "meaning"
  className: "table-view-cell"
  onRender:->
    @$el.click => @trigger "click"

      
MeaningsCollectionView = Marionette.CollectionView.extend
  className: "table-view"
  childView: MeaningView
  childEvents:
    click: (ev)->
      meaning = ev.model
      phrase = @phrase
      phrase.set("answer", ev.model)
      @trigger "meaning_picked"


PhraseView = Marionette.ItemView.extend
  template: "phrase"
  className: "table-view-cell"
  onRender:->
    @$el.click => @trigger "click"

  
PhrasesCollectionView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"
  className: "table-view"
  tagName: "ul"
  childEvents:
    click: (ev)->
      @trigger "phrase_clicked", phrase:ev.model

QuizView = Marionette.ItemView.extend
  template: false
  initialize: (options)->

    @phrases_view = new PhrasesCollectionView(collection: @options.collection)
    @phrases_view.on "phrase_clicked", (ev)=>
      console.log "quiz noticed phrase was clicked"
      console.log ev
      @meanings_view.phrase = ev.phrase
      @$el.html(@meanings_view.render().el)

    @meanings_view = new MeaningsCollectionView(
      collection: @options.collection
    )
    @meanings_view.on "meaning_picked", (ev)=>
      console.log "noticed that meaning picked"
      @$el.html(@phrases_view.render().el)

  onRender: ->
    @$el.html(@phrases_view.render().el)






    


module.exports =
  PhraseView: PhraseView
  PhrasesView: PhrasesCollectionView
  QuizView: QuizView
