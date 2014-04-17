# Needs JQuery

revert = (el) ->
  document.execCommand('undo')
  el.blur()

save = (event, el, socket) ->
  key =  $(el).data('single-line')
  console.log 'html: ' + $(el).html()
  value = $(el).text()
  console.log 'drafting ' + value
  # socket.emit('draft', [key, value])
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
        when 13 then save(event, this, socket)
    .blur (event) -> save(event, this, socket)
