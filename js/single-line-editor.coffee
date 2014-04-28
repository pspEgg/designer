# Needs JQuery

revert = (el) ->
  document.execCommand('undo')
  el.blur()

draft = (event, el, socket) ->
  attr =  $(el).data('design-text')
  # console.log 'html: ' + $(el).html()
  attr.text = $(el).text()
  console.log 'drafting ' + attr.text
  socket.emit('draft', attr)
  

exports.editable = (element, socket) ->
  console.log('making a editable')
  $(element)  
    .attr('contenteditable', true)
    .keydown (event) ->
      switch event.which
        # ES{C Key
        when 27 then revert(this)
        # Enter Key
        when 13
          # prevent creation of "new line"
          event.preventDefault()
          this.blur()
    .blur (event) -> draft(event, this, socket)

