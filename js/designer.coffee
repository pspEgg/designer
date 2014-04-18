socket = io.connect('/')

single = require './single-line-editor'
list = require './list-manager'

single.editable(socket)
list.manageLists(socket)