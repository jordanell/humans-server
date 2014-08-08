mongoose  = require 'mongoose'
Schema    = mongoos.Schema

UserSchema = new Schema
  uuid: String

module.exports = mongoose.model 'User', UserSchema