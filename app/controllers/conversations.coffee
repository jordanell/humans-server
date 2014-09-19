Controller    = require './base_controller'
Conversation  = require '../models/conversation'
User          = require '../models/user'
Message       = require '../models/message'
presence      = require '../presence_manager'
_             = require 'underscore'

class ConversationsController extends Controller

    # POST /conversations
    create: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      @getRandomUser req.param('user_id'), (err, user) =>
        return res.json err: "Could not find a user" unless user

        userIds = [user.id, req.param('user_id')]
        time    = Date()

        conversation = new Conversation({id: @getId(), userIds: userIds, name: user.name, created: time, updated: time})

        conversation.save (err) =>
          if err
            res.send err
          else
            presence.get().broadcastObject 'conversation', conversation, _.filter conversation.userIds, (userId) => userId isnt req.param('user_id')
            res.json {result: "success", conversation: conversation}

    # GET /conversations
    index: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      unless req.param('page')
        req.params.page = 1

      Conversation.find {userIds: {$in: [req.param('user_id')]}}, null, {sort: {updated: -1}, skip: ((req.param('page')-1) * @PAGE_SIZE), limit: (@PAGE_SIZE)}, (err, conversations) =>
        if err then res.send err
        return res.json {result: "success", conversations: conversations}

    # GET /conversations/:id
    show: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      Conversation.findOne { id: req.param('conversation_id') }, (err, conversation) =>
        if err then res.send err

        if !_.contains(conversation.userIds, req.param('user_id'))
          return res.json {err: "Unauthorized access"}

        return res.json {result: "success", conversation: conversation}

    # PUT /conversations/leave
    leave: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      Conversation.findOne { id: req.param('conversation_id') }, (err, conversation) =>
        if err then res.send err

        if !_.contains(conversation.userIds, req.param('user_id'))
          return res.json {err: "Unauthorized access"}

        conversation.userIds = _.without(conversation.userIds, req.param('user_id'))

        message = new Message({id: @getId(), body: "The other human has left this conversation", conversationId: req.param('conversation_id'), created: Date()})

        message.save () =>
          presence.get().broadcastObject 'message', message, _.filter conversation.userIds, (userId) => userId isnt req.param('user_id')

        conversation.save (err) =>
          if err then return res.send err
          res.json {result: "success", message: "Removed from conversation"}

    getRandomUser: (userId, cb, level = 0) =>
      if level >= 5
        return cb({err: "Could not find user"}, null)

      User.random (err, user) =>
        if err then return cb({err: "Could not find user"}, null)

        if user.id == userId
          return @getRandomUser(userId, cb, level + 1)

        return cb(null, user)

module.exports = new ConversationsController()