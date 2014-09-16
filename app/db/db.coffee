mongoose  = require 'mongoose'
config    = require 'config'

dbName = config.get('server.dbName')

mongoose.connect "mongodb://localhost/#{dbName}"