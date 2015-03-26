$ = require "jquery"
Marionette = require "backbone.marionette"
Phrase = require "./model"

MeaningView = Marionette.ItemView.extend
  template: "meaning"
  className: "table-view-cell"
  ui:
    "meaning": ".meaning"
  events:
    "click @ui.meaning": "on_meaning_clicked"
  on_meaning_clicked:->
    console.log "meaning clicked on meaning view"
    @triggerMethod "on_meaning_clicked"

      
MeaningsCollectionView = Marionette.CollectionView.extend
  className: "table-view"
  childView: MeaningView
  childEvents:
    "on_meaning_clicked": (ev)->
      console.log "meaning clicked on meanings collection view"
      @triggerMethod "meaning_picked"


PhraseView = Marionette.ItemView.extend
  template: "phrase"
  className: "table-view-cell"
  ui:
    "phrase": ".phrase"
  events:
    "click @ui.phrase": "on_phrase_clicked"
  on_phrase_clicked: ->
    console.log "PhraseView phrase clicked"
    @triggerMethod "phrase_clicked"

  
PhrasesCollectionView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"
  className: "table-view"
  tagName: "ul"
  childEvents:
    "phrase_clicked": (ev)->
      console.log "phrase collection view phrase clicked"
      @triggerMethod "phrase_clicked", phrase:ev.model

QuizView = Marionette.ItemView.extend
  template: false
  initialize: (options)->

    @phrases_view = new PhrasesCollectionView(collection: @options.collection)
    @phrases_view.on "phrase_clicked", (ev)=>
      @meanings_view.phrase = ev.phrase
      @$el.html(@meanings_view.render().el)

    @meanings_view = new MeaningsCollectionView(
      collection: @options.collection
    )
    @meanings_view.on "meaning_picked", (ev)=>
      @$el.html(@phrases_view.render().el)

  onRender: ->
    @$el.html(@phrases_view.render().el)






    


module.exports =
  PhraseView: PhraseView
  PhrasesView: PhrasesCollectionView
  QuizView: QuizView
