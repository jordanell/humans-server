module.exports = class PresenceManager

  instance = null

  onlineUserIds = {}

  @get: ->
    if not @instance?
      instance = new @
    
    instance

  connectUser: (userId, socket) ->
    @onlineUserIds[userId] = socket

  disconnectUser: (userId) ->
    delete @onlineUserIds userId

  getOnlineUsers: ->
    return @onlineUserIds

  isUserOnline: (userId) ->
    userId in @onlineUserIds