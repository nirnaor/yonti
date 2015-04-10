Swiper = require "swiper"

class Slide
  constructor: (@selector)->
    @swiper = new Swiper(@selector, {
      direction: 'horizontal'
    })

  to: (slide_number)->
    return true
    @swiper.slideTo(slide_number)

module.exports =
  Slide: Slide
