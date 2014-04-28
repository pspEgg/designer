socket = io.connect('/')

# single = require './single-line-editor'
# list = require './list-manager'

# single.editable(socket)
# list.manageLists(socket)

PopUp = require './popup'

popup = new PopUp(socket)

$('[data-design-text]').on 'click.preventDefault', (event) -> event.preventDefault()
$('[data-design-text]').on 'click.popup', (event) ->
  popup.setTargetAndUnhide(this)
