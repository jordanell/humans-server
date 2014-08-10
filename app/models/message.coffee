mongoose  = require 'mongoose'
Schema    = mongoose.Schema

MessageSchema = new Schema
  id:             String
  body:           String
  userId:         String
  conversationId: String
  created:        Date

module.exports = mongoose.model 'User', MessageSchema