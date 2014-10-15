Controller    = require './base_controller'
Message       = require '../models/message'
Conversation  = require '../models/conversation'
presence      = require '../presence_manager'
_             = require 'underscore'

class MessagesController extends Controller

    # POST /messages
    create: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        Conversation.findOne { id: req.param('conversation_id') }, (err, conversation) =>
          if err
            return res.send err

          if !_.contains(conversation.users, user._id)
            return res.json err: "Unauthorized conversation access"

          message = new Message({id: @getId(), body: req.param('body'), userId: req.param('user_id'), conversationId: req.param('conversation_id'), created: Date()})

          message.save (err) =>
            if err
              res.send err
            else
              conversation.updated = message.created
              conversation.lastMessage = message._id
              conversation.seenUsers = [user._id]

              conversation.save (err) =>
                if err
                  res .send err
                else
                  presence.get().broadcastObject 'message', message, _.filter conversation.users, (userId) => userId isnt user._id
                  res.json {result: "success", message: message}

    # GET /messages
    index: (req, res) =>
      unless req.param('conversation_id')
        return res.json err: "Must provide a conversation id"

      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        Conversation.findOne { id: req.param('conversation_id') }, (err, conversation) =>
          if err then return res.send err

          if !_.contains(conversation.users, user._id)
            return res.json err: "Unauthorized conversation access"

          unless req.param('page')
            req.params.page = 1

          Message.find {conversationId: conversation.id, }, null, {sort: {created: -1}, skip: ((req.param('page')-1) * @PAGE_SIZE), limit: (@PAGE_SIZE)}, (err, messages) =>
            if err then res.send err
            return res.json {result: "success", messages: messages}

module.exports = new MessagesController()