express       = require 'express'
http          = require 'http'
socketio      = require 'socket.io'
config        = require 'config'
createRoutes  = require './routes'
presence      = require './presence_manager'

app     = express()
server  = http.createServer app
io      = socketio.listen server

port = config.get('server.port')

router = createRoutes()

app.use '/api', router

io.on 'connection', (socket) =>
  socket.on 'connect user', (data, cb) =>
    presence.get().connectUser(data.userId, socket)

  socket.on 'disconnect', (data) =>
    presence.get().disconnectUser(data.userId)

server.listen port

console.log "Make it rain on: #{port}"
