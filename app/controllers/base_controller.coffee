uuid = require 'uuid'

module.exports = class Controller

  getId: ->
    uuid.v4()
  