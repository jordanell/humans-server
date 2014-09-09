Controller    = require './base_controller'
Conversation  = require '../models/conversation'
User          = require '../models/user'
Message       = require '../models/message'
_             = require 'underscore'

class ConversationsController extends Controller

    # POST /conversations
    create: (req, res) =>
      unless req.query.user_id
        return res.json err: "Must provide a user id"

      @getRandomUser req.query.user_id, (err, user) =>
        return res.json err: "Could not find a user" if user is null

        userIds = [user.id, req.query.user_id]
        time    = Date()

        conversation = new Conversation({id: @getId(), userIds: userIds, name: user.name, created: time, updated: time})

        conversation.save (err) =>
          if err
            res.send err
          else
            res.json {result: "success", conversation: conversation}

    # GET /conversations
    index: (req, res) =>
      unless req.query.user_id
        return res.json err: "Must provide a user id"

      unless req.query.page
        req.query.page = 1

      Conversation.find {userIds: {$in: [req.query.user_id]}}, null, {sort: {updated: -1}, skip: ((req.query.page-1) * @PAGE_SIZE), limit: (@PAGE_SIZE)}, (err, conversations) =>
        if err then res.send err
        return res.json {result: "success", conversations: conversations}

    # GET /conversations/:id
    show: (req, res) =>
      unless req.query.user_id
        return res.json err: "Must provide a user id"

      Conversation.findOne { id: req.query.conversation_id }, (err, conversation) =>
        if err then res.send err

        if !_.contains(conversation.userIds, req.query.user_id)
          return res.json {err: "Unauthorized access"}

        return res.json {result: "success", conversation: conversation}

    # PUT /conversations/leave
    leave: (req, res) =>
      unless req.query.user_id
        return res.json err: "Must provide a user id"

      Conversation.findOne { id: req.query.conversation_id }, (err, conversation) =>
        if err then res.send err

        if !_.contains(conversation.userIds, req.query.user_id)
          return res.json {err: "Unauthorized access"}

        conversation.userIds = _.without(conversation.userIds, req.query.user_id)

        message = new Message({id: @getId(), body: "The other human has left this conversation", userId: req.query.user_id, conversationId: req.query.conversation_id, created: Date()})

        message.save () =>

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