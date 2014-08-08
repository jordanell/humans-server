mongoose  = require 'mongoose'
Schema    = mongoos.Schema

UserSchema = new Schema
  id: String

module.exports = mongoose.model 'User', UserSchema