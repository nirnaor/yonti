os = ->
  userAgent = navigator.userAgent or navigator.vendor or window.opera
  if userAgent.match(/iPad/i) or userAgent.match(/iPhone/i) or userAgent.match(/iPod/i)
    'ios'
  else if userAgent.match(/Android/i)
    'android'
  else
    'unknown'

module.exports =
  os: os
