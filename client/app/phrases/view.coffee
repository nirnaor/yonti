$ = require "jquery"
Marionette = require "backbone.marionette"
Phrase = require "./model"

PhraseView = Marionette.ItemView.extend
  template: "phrase"
  className: "table-view-cell"
  onRender:->
    @$el.click => @trigger "click"

MeaningView = Marionette.ItemView.extend
  template: "meaning"
  className: "table-view-cell"

      
MeaningsCollectionView = Marionette.CollectionView.extend
  className: "table-view"
  childView: MeaningView

  
PhrasesCollectionView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"
  className: "table-view"
  tagName: "ul"
  childEvents:
    click: (ev)->
      meanings_view = new MeaningsCollectionView
        collection: @collection

      $("div.content").html(meanings_view.render().el)
    

module.exports =
  PhraseView: PhraseView
  PhrasesView: PhrasesCollectionView
