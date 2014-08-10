mongoose  = require 'mongoose'
Schema    = mongoose.Schema

ConversationSchema = new Schema
  id:       String
  userIds:  [String]
  created:  Date
  updated:  Date

module.exports = mongoose.model 'Conversation', ConversationSchema