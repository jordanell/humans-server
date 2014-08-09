mongoose  = require 'mongoose'
Schema    = mongoose.Schema

UserSchema = new Schema
  id: String

module.exports = mongoose.model 'User', UserSchema