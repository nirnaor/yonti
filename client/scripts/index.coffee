$ = require "jquery"
Phrase = require "./models/phrase"
PhrasesViews = require "./views/phrases"

phrases_view = new PhrasesViews.PhrasesViews(
  el: $("div.main")
)
phrases_view.render()
phrase = new Phrase()
phrase.set("first", "gil")
console.log phrase.get "first"
