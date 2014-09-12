global.logger = require("../utils/logger")

express       = require 'express'
http          = require 'http'
ws 			      = require 'ws'
config        = require 'config'
createRoutes  = require './routes'
presence      = require './presence_manager'

db = require './db/db'

app     = express()
server  = http.createServer app

port        = config.get('server.port')
socketPort  = config.get('server.socketPort')

router = createRoutes()

app.use '/', router

wss = new ws.Server {port: socketPort}

wss.on 'connection', (socket) =>
  socket.on 'open', (data, cb) =>
    presence.get().connectUser(data.userId, socket)

  socket.on 'close', (data) =>
    presence.get().disconnectUser(data.userId)

server.listen port

console.log "Make it rain on: #{port}"
