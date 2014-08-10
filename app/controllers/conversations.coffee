Controller    = require './base_controller'
Conversation  = require '../models/conversation'
User          = require '../models/user'

class ConversationsController extends Controller

    # POST /conversations
    create: (req, res) ->
      unless req.params.user_id
        return res.json err: "Unauthorized access"

      user = @findRandomUser(req.params.user_id)

      userIds = [user.id, req.params.user_id]
      time    = Date()

      conversation = new Conversation({id: getId(), userIds: usersIds, created: time, updated: time})

      conversation.save (err) =>
        if err
          res.send err
        else
          res.json {result: "success", conversation: conversation}

    # Helper methods
    findRandomUser: (currentUserId) ->
      total   = User.count() - 1
      random  = Math.floor(Math.random() * total);

      userId = currentUserId
      while(userId is currentUserId)
        user    = User.find().limit(-1).skip(random).next()
        userId  = user.id

      return user


module.exports = new ConversationsController()