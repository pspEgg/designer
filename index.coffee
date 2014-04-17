# set helpers: app.local.something -> need app
# serve /designerjs/master.js -> need app

# middleware to inject code into html responseses
# https://www.npmjs.org/package/connect-inject
socket = require 'socket.io'
http = require 'http'
path = require 'path'

fsdb = require './fsdb'

scriptLoc = '/npm/designer.js'
scriptTag = "<script type='text/javascript' src='#{scriptLoc}'></script>"

exports.design = (app) ->
  app.get scriptLoc, (req, res) -> res.sendfile(path.join(__dirname, './public/designer.js'))

  # bottom of page injection
  app.use require('connect-inject')({snippet: scriptTag})

  app.locals.db = new fsdb(path.join(process.env.PWD, './default.yml'))
  # reload database
  # app.use (req, res, next) ->
  #   next()

  # manual script 'injection'
  # app.locals.designerScriptTag = scriptTag

  # make server for socket.io to piggy back on
  # server = http.createServer(app)
  # socket.listen(server)
