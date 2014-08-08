mongoose  = require 'mongoose'
Schema    = mongoos.Schema

MessageSchema = new Schema
  id:             String
  body:           String
  user:           String
  conversationId: String
  created:        Date

module.exports = mongoose.model 'User', MessageSchema