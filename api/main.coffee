express   = require 'express'
socketio  = require 'socket.io'
config    = require './config/index'

app = express.createServer()
io  = socketio.listen app

port = 4444

app.listen port

console.log "Make it rain on: #{port}"
