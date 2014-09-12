module.exports = class PresenceManager

  instance = null

  onlineUserIds = {}

  @get: ->
    if not @instance?
      instance = new @
    
    instance

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