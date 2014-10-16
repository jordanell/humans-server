mongoose  = require 'mongoose'
Schema    = mongoose.Schema

ConversationSchema = new Schema
  id:           String
  users:        [{ type: String, ref: 'User' }]
  lastMessage:  { type: String, ref: 'Message' }
  seenUsers:    [{ type: String, ref: 'User'}]
  created:      Date
  updated:      Date

module.exports = mongoose.model 'Conversation', ConversationSchema