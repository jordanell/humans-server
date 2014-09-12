module.exports = class PresenceManager

  instance = null

  class PrivateClass
    onlineUserIds: {}

    connectUser: (userId, socket) ->
      return unless userId and socket
      @onlineUserIds[userId] = socket

    disconnectUser: (userId) ->
      return unless userId
      delete @onlineUserIds[userId]

    getOnlineUsers: ->
      return @onlineUserIds

    isUserOnline: (userId) ->
      return false unless userId
      userId in @onlineUserIds

    getUser: (userId) ->
      return @onlineUserIds[userId]

  @get: ->
    instance ?= new PrivateClass()