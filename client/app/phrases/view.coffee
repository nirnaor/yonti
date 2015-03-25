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
  onRender:->
    @$el.click => @trigger "click"

      
MeaningsCollectionView = Marionette.CollectionView.extend
  className: "table-view"
  childView: MeaningView
  childEvents:
    click: (ev)->
      meaning = ev.model
      phrase = @options.phrase
      phrase.set("answer", ev.model)
      @trigger "meaning_picked"


  
PhrasesCollectionView = Marionette.CollectionView.extend
  childView: PhraseView
  template: "phrases"
  className: "table-view"
  tagName: "ul"
  childEvents:
    meaning_picked: (ev)->
      console.log "nir"
    click: (ev)->
      console.log ev
      meanings_view = new MeaningsCollectionView
        collection: @collection
        phrase: ev.model
      meanings_view.on "meaning_picked", (ev)=>
        console.log "noticed that meaning picked"
        $("div.content").html(@render().el)

      $("div.content").html(meanings_view.render().el)
    


module.exports =
  PhraseView: PhraseView
  PhrasesView: PhrasesCollectionView
