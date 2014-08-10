uuid = require 'uuid'

module.exports = class Controller

  PAGE_SIZE: 20

  getId: ->
    uuid.v4()
  