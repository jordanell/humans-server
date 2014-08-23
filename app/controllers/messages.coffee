Controller    = require './base_controller'
Message       = require '../models/message'
Conversation  = require '../models/conversation'
_             = require 'underscore'

class MessagesController extends Controller

    # POST /messages
    create: (req, res) =>
      Conversation.findOne { id: req.query.conversation_id }, (err, conversation) =>
        if err
          return res.send err

        if !_.contains(conversation.userIds, req.query.user_id) 
          return res.json err: "Unauthorized conversation access"

        message = new Message({id: @getId(), body: req.query.body, userId: req.query.user_id, conversationId: req.query.conversation_id, created: Date()})

        message.save (err) =>
          if err
            res.send err
          else
            conversation.updated = message.created
            conversation.lastMessage = message.body
            conversation.save (err) =>
              if err
                res .send err
              else
                res.json {result: "success", message: message}

    # GET /messages
    index: (req, res) =>
      unless req.query.conversation_id
        return res.json err: "Must provide a conversation id"

      unless req.query.user_id
        return res.json err: "Must provide a user id"

      Conversation.findOne { id: req.query.conversation_id }, (err, conversation) =>
        if err then return res.send err

        if !_.contains(conversation.userIds, req.query.user_id) 
          return res.json err: "Unauthorized conversation access"

        skip = 0
        if req.query.page and !isNaN(req.query.page) and req.query.page >= 1
          page = req.query.page - 1
          skip = @PAGE_SIZE * page

        Message.find {conversationId: conversation.id, }, null, {}, (err, messages) =>
          if err then res.send err
          return res.json {result: "success", messages: messages}




module.exports = new MessagesController()