Swiper = require "swiper"

class Slide
  constructor: ->
    @swiper = new Swiper(".content", {
      direction: 'horizontal'
    })

  to: (slide_number)->
    @swiper.slideTo(slide_number)

module.exports =
  Slide: Slide
