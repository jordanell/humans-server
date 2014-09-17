global.logger = require("../utils/logger")

express       = require 'express'
http          = require 'http'
ws 			      = require 'ws'
config        = require 'config'
bodyParser    = require 'body-parser'
createRoutes  = require './routes'
presence      = require './presence_manager'
db            = require './db/db'

# Set up the humans api
app     = express()
server  = http.createServer app

port        = config.get('server.port')
socketPort  = config.get('server.socketPort')

app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })

router = createRoutes()
app.use '/', router

wss = new ws.Server {port: socketPort}
console.log "Make it sockety on: #{socketPort}"

wss.on 'connection', (socket) =>

  socket.on 'message', (data) =>
    data = JSON.parse data

    if data.userId
      presence.get().connectUser(data.userId, socket)

  socket.on 'close', (data) =>
    presence.get().disconnectUser(data.userId)

server.listen port
console.log "Make it restful on: #{port}"

# Set up the humans landing page
# webApp = express()

# webApp.use('/landing', express.static(__dirname + '/public/landing'))

# console.log __dirname + '/public'

# webApp.listen 80
# console.log "Making it user friendly on: 80"
