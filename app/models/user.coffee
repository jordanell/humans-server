mongoose  = require 'mongoose'
Schema    = mongoose.Schema

UserSchema = new Schema
  _id:  Number
  id:   String
  name: String

UserSchema.statics.random = (callback) ->
  @count ((err, count) =>
    return callback(err)  if err
    rand = Math.floor(Math.random() * count)
    @findOne().skip(rand).exec callback
    return
  ).bind(this)
  return

module.exports = mongoose.model 'User', UserSchema