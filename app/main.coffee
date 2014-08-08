express   = require 'express'
http      = require 'http'
socketio  = require 'socket.io'
config    = require 'config'

app     = express()
server  = http.createServer app
io      = socketio.listen server

port = config.get('server.port')

server.listen port

console.log "Make it rain on: #{port}"
