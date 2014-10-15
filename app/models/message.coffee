mongoose  = require 'mongoose'
Schema    = mongoose.Schema

MessageSchema = new Schema
  _id:            Number
  id:             String
  body:           String
  userId:         String
  conversationId: String
  created:        Date

module.exports = mongoose.model 'Message', MessageSchema