# Needs JQuery

revert = (el) ->
  document.execCommand('undo')
  el.blur()

save = (event, el, socket) ->
  attr =  $(el).data('design-text')
  console.log 'html: ' + $(el).html()
  attr.text = $(el).text()
  console.log 'drafting ' + attr.text
  socket.emit('draft', attr)
  el.blur()
  event.preventDefault()

exports.editable = (socket) ->
  $('[data-design-text]')
    .attr('contenteditable', true)
    .keydown (event) ->
      switch event.which
        # ESC Key
        when 27 then revert(this)
        # Enter Key
        when 13
          this.blur()
          event.preventDefault()
    .blur (event) -> save(event, this, socket)
