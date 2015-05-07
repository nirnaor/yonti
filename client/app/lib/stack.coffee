class Stack
  constructor: (array=[])->
    @items = array
  pop: -> @items.pop()
  push: (item)-> @items.push item

module.exports = Stack
