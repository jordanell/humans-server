mongoose  = require 'mongoose'
Schema    = mongoose.Schema

ConversationSchema = new Schema
  id:           String
  userIds:      []
  name:         String
  lastMessage:  String
  created:      Date
  updated:      Date

module.exports = mongoose.model 'Conversation', ConversationSchema