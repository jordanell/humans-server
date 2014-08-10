Controller    = require './base_controller'
Conversation  = require '../models/conversation'
User          = require '../models/user'

class ConversationsController extends Controller

    # POST /conversations
    create: (req, res) ->
      unless req.params.user_id
        return res.json err: "Must provide a user id"

      user = @findRandomUser(req.params.user_id)

      userIds = [user.id, req.params.user_id]
      time    = Date()

      conversation = new Conversation({id: getId(), userIds: usersIds, created: time, updated: time})

      conversation.save (err) =>
        if err
          res.send err
        else
          res.json {result: "success", conversation: conversation}

    # GET /conversations
    index: (req, res) ->
      unless req.params.user_id
        return res.json err: "Must provide a user id"

      Conversation.find {userIds: {$in: [req.params.user_id]}}, (err, converations) =>
        if err then res.send err

        return res.json {result: "success", conversations, conversations}

    # GET /conversations/:id
    show: (req, res) ->
      unless req.params.user_id
        return res.json err: "Must provide a user id"

      Conversation.findById req.params.user_id (err, conversation) =>
        if err then res.send err

        if !_.contains(conversation.userIds, req.user_id)
          return res.json {err: "Unauthorized access"}

        return res.json {result: "success", conversation: conversation}


    ### Helper methods ###


    findRandomUser: (currentUserId) ->
      total   = User.count() - 1
      random  = Math.floor(Math.random() * total);

      userId = currentUserId
      while(userId is currentUserId)
        user    = User.find().limit(-1).skip(random).next()
        userId  = user.id

      return user


module.exports = new ConversationsController()