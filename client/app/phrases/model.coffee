Backbone = require "backbone"
Phrase = Backbone.Model.extend({})
PhraseCollection = Backbone.Collection.extend
  initialize: (models, options)->
    console.log "Phrase collection initialize"

  
module.exports =
  Model: Phrase
  Collection: PhraseCollection
