mongoose  = require 'mongoose'
Schema    = mongoose.Schema

ConversationSchema = new Schema
  _id:          Number
  id:           String
  users:        [{ type: Number, ref: 'User' }]
  lastMessage:  { type: Number, ref: 'Message' }
  seenUsers:    [{ type: Number, ref: 'User'}]
  created:      Date
  updated:      Date

module.exports = mongoose.model 'Conversation', ConversationSchema