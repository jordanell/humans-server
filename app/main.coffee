express       = require 'express'
http          = require 'http'
socketio      = require 'socket.io'
config        = require 'config'
createRoutes  = require './routes'

app     = express()
server  = http.createServer app
io      = socketio.listen server

port = config.get('server.port')

router = createRoutes()

app.use '/api', router

server.listen port

console.log "Make it rain on: #{port}"
