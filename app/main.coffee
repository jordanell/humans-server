express   = require 'express'
http      = require 'http'
socketio  = require 'socket.io'
config    = require './config/index'

app     = express()
server  = http.createServer app
io      = socketio.listen server

port = 4444

server.listen port

console.log "Make it rain on: #{port}"
