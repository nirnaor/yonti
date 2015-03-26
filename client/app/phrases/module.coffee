Phrase = require "./model"
PhraseViews=  require "./view"
module.exports =
  Model: Phrase.Model
  Collection: Phrase.Collection
  Views:
    Quiz: PhraseViews.QuizView
  
