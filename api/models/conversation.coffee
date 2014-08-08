mongoose  = require 'mongoose'
Schema    = mongoos.Schema

ConversationSchema = new Schema
  id:       String
  userIds:  [String]
  created:  Date
  updated:  Date

module.exports = mongoose.model 'User', ConversationSchema