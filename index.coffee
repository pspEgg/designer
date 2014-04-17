# set helpers: app.local.something -> need app
# serve /designerjs/master.js -> need app

# middleware to inject code into html responseses
# https://www.npmjs.org/package/connect-inject

http = require 'http'
path = require 'path'

fsdb = require './fsdb'

jqueryLoc = '/npm/jquery.js'
scriptLoc = '/npm/designer.js'
jqueryTag = "<script type='text/javascript' src='#{jqueryLoc}'></script>"
scriptTag = "<script type='text/javascript' src='#{scriptLoc}'></script>"
socketTag = "<script type='text/javascript' src='/socket.io/socket.io.js'></script>"

exports.design = (app) ->
  app.get jqueryLoc, (req, res) -> res.sendfile(path.join(__dirname, './public/jquery.js'))
  app.get scriptLoc, (req, res) -> res.sendfile(path.join(__dirname, './public/designer.js'))

  # bottom of page injection
  app.use require('connect-inject')({snippet: [jqueryTag, socketTag, scriptTag]})

  app.locals.db = new fsdb(path.join(process.env.PWD, './default.yml'))
  # reload database
  # app.use (req, res, next) ->
  #   next()

  # manual script 'injection'
  # app.locals.designerScriptTag = scriptTag

  # make server for socket.io to piggy back on
  server = http.createServer(app)
  io = require('socket.io').listen(server)
  io.sockets.on 'connection', (socket) ->
    socket.on 'draft', (data) ->

  return server