Controller    = require './base_controller'
Message       = require '../models/message'
Conversation  = require '../models/conversation'

class MessagesController extends Controller

    # POST /messages
    create: (req, res) ->
      Conversation.findById req.params.conversation_id (err, conversation) =>
        if err
          return res.send err

        if !_.contains(conversation.userIds, req.params.user_id) 
          return res.json err: "Unauthorized conversation access"

        message = new Message({id: getId(), body: req.params.body, userId: req.params.user_id, conversationId: req.params.conversation_id, created: Date()})

        message.save (err) =>
          if err
            res.send err
          else
            conversation.updated = message.created
            conversation.save (err) =>
              if err
                res .send err
              else
                res.json {result: "success", message: message}

    # GET /messages
    index: (req, res) ->
      unless req.params.conversation_id
        return res.json err: "Must provide a conversation id"

      unless req.params.user_id
        return res.json err: "Must provide a user id"

      Conversation.findById req.params.conversation_id, (err, conversation) =>
        if err then return res.send err

        if !_.contains(conversation.userIds, req.params.user_id) 
          return res.json err: "Unauthorized conversation access"

        skip = 0
        if req.params.page and !isNaN(req.params.page) and req.params.page >= 1
          page = req.params.page - 1
          skip = @PAGE_SIZE * page

        Message.find({conversationId: conversation.id, }).sort({created: -1}).skip(skip).limit(@PAGE_SIZE)



module.exports = new MessagesController()