mongoose  = require 'mongoose'
Schema    = mongoose.Schema

ConversationSchema = new Schema
  id:           String
  userIds:      []
  name:         String
  lastMessage:  String
  seenIds:      []
  created:      Date
  updated:      Date

module.exports = mongoose.model 'Conversation', ConversationSchema