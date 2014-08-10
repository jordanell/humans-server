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

module.exports = new MessagesController()