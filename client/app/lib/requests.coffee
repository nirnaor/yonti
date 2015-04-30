$ = require "jquery"

ajax = (method, url, data, success, error)->
  $.ajax
    url: "http://localhost:3000/#{url}"
    method: method
    crossDomain: true
    xhrFields:
      withCredentials: true
    data: data
    dataType: "json"
    success: success
    error: error

post = (url, data, success, error)->
  ajax("POST", url, data, success, error)

get = (url, data, success, error)->
  ajax("GET", url, data, success, error)

module.exports =
  post: post
  get: get
