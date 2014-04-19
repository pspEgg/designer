socket = io.connect('/')

single = require './single-line-editor'
list = require './list-manager'

single.editable(socket)
list.manageLists(socket)

$('.beer-feature').find('[data-design-text]').removeAttr('contenteditable')