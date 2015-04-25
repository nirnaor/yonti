$ = require "jquery"

post = (url, data, success, error)->
  $.ajax
    url: "http://localhost:3000/#{url}"
    method: "POST"
    crossDomain: true
    xhrFields:
      withCredentials: true
    data: data
    dataType: "json"
    success: success
    error: error

module.exports =
  post: post
