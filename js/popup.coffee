editor = require './single-line-editor'

class PopUp
  # Save Socket
  constructor: (@socket) ->
    @edit = $("<button data-design-action-edit>Edit</button>")
    @popup = $("<div></div>").append @edit
    @popup.css {
      position: 'absolute'
      'z-index': 200
    }
    @popup.appendTo('body')

  # Main Function
  setTargetAndUnhide: (target) ->
    console.log 'set target: ' + $(target).text()
    @target = $(target)
    @setEditTarget()
    @position()

  setEditTarget: () ->
    @edit.click () =>
      console.log "Clicked Edit Button"
      @beginEdit()

  position: () ->
    {top, left} = @target.offset()
    top = top + @target.height()
    @popup.css {
      top: top
      left: left
    }

  beginEdit: () ->
    editor.editable(@target, @socket)
    @target.focus()

module.exports = PopUp
    
