# set helpers: app.local.something -> need app
# serve /designerjs/master.js -> need app

# middleware to inject code into html responseses
# https://www.npmjs.org/package/connect-inject

http = require 'http'
path = require 'path'

fsdb = require './fsdb'

jqueryLoc = '/npm/jquery.js'
scriptLoc = '/npm/designer.js'
toolTipLoc = '/npm/tooltip.js'
jqueryTag = "<script type='text/javascript' src='#{jqueryLoc}'></script>"
scriptTag = "<script type='text/javascript' src='#{scriptLoc}'></script>"
socketTag = "<script type='text/javascript' src='/socket.io/socket.io.js'></script>"
toolTipTag = "<script type='text/javascript' src='#{toolTipLoc}'></script>"

exports.design = (app) ->
  app.get jqueryLoc, (req, res) -> res.sendfile(path.join(__dirname, './public/jquery.js'))
  app.get scriptLoc, (req, res) -> res.sendfile(path.join(__dirname, './public/designer.js'))
  # app.get toolTipLoc, (req, res) -> res.sendfile(path.join(__dirname, './public/tooltip.js'))

  # bottom of page injection
  app.use require('connect-inject')({snippet: [socketTag, scriptTag]})

  app.locals.db = new fsdb(path.join(process.env.PWD, './default.yml'))
  # reload databased
  # app.use (req, res, next) ->
  #   next()

  # manual script 'injection'
  # app.locals.designerScriptTag = scriptTag

  # make server for socket.io to piggy back on
  server = http.createServer(app)
  io = require('socket.io').listen(server)
  io.set 'log level', 1
  io.sockets.on 'connection', (socket) ->
    socket.on 'draft', (data) ->
      console.log "Drafting #{JSON.stringify data}"
      app.locals.db.draft(data)
    socket.on 'delete', (data) ->
      app.locals.db.delete(data)

  return server