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

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        unless user
          return res.json {err: "Could not find user"}

        originalUser = user

        @getRandomUser req.param('user_id'), (err, user) =>
          return res.json err: "Could not find a user" unless user

          users = [user._id, originalUser._id]
          time  = Date()

          conversation = new Conversation({id: @getId(), users: users, created: time, updated: time})
          conversation.save (err) =>
            if err
              res.send err
            else
              Conversation.populate conversation, [{path: 'users'}], (err, conversation) =>
                if err
                  return res.send err

                presence.get().broadcastObject 'conversation', conversation, _.pluck(_.reject(conversation.users, (cUser) => cUser.id is originalUser.id), "id")
                res.json {result: "success", conversation: conversation}

    # GET /conversations
    index: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      unless req.param('page')
        req.params.page = 1

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        unless user
          return res.json {err: "Could not find user"}

        Conversation.find({users: {$in: [user._id]}}, null, {sort: {updated: -1}, skip: ((req.param('page')-1) * @PAGE_SIZE), limit: (@PAGE_SIZE)}).populate('users seenUsers lastMessage').exec (err, conversations) =>
          if err then res.send err
          return res.json {result: "success", conversations: conversations}

    # GET /conversations/:id
    show: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        unless user
          return res.json {err: "Could not find user"}

        Conversation.findOne({ id: req.param('id') }).populate('users seenUsers lastMessage').exec (err, conversation) =>
          if err then res.send err

          unless conversation
            return res.json {err: "Could not find conversation"}

          unless _.contains(_.pluck(conversation.users, "id"), req.param('user_id'))
            return res.json {err: "Unauthorized access"}

          return res.json {result: "success", conversation: conversation}

    # PUT /conversations/seen
    seen: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        unless user
          return res.json {err: "Could not find user"}

        Conversation.findOne({ id: req.param('conversation_id') }).populate('users').exec (err, conversation) =>
          if err then res.send err

          unless _.contains(_.pluck(conversation.users, "id"), req.param('user_id'))
            return res.json {err: "Unauthorized access"}

          conversation.seenUsers.push user._id

          conversation.save (err) =>
            if err then return res.send err
            res.json {result: "success", message: "Seen conversation"}

    # PUT /conversations/leave
    leave: (req, res) =>
      unless req.param('user_id')
        return res.json err: "Must provide a user id"

      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err
          return res.send err

        unless user
          return res.json {err: "Could not find user"}

        Conversation.findOne({ id: req.param('conversation_id') }).populate('users').exec (err, conversation) =>
          if err then res.send err

          unless _.contains(_.pluck(conversation.users, "id"), req.param('user_id'))
            return res.json {err: "Unauthorized access"}

          conversation.users = _.reject conversation.users, (cUser) => cUser.id is user.id

          message = new Message({id: @getId(), body: "The other human has left this conversation", conversationId: req.param('conversation_id'), created: Date()})
          conversation.lastMessage = message._id

          message.save () =>
            presence.get().broadcastObject 'message', message, _.pluck(_.reject(conversation.users, (cUser) => cUser.id is user.id), "id")

          conversation.save (err) =>
            if err then return res.send err
            res.json {result: "success", message: "Removed from conversation"}

    getRandomUser: (userId, cb, level = 0) =>
      # Check for online users first
      if level is 0
        id = presence.get().getRandomUser(userId)
        if id
          User.findOne { id: id }, (err, user) =>
            unless err
              return user

      if level >= 5
        return cb({err: "Could not find user"}, null)

      User.random (err, user) =>
        if err or !user? then return cb({err: "Could not find user"}, null)

        if user.id is userId
          return @getRandomUser(userId, cb, level + 1)

        return cb(null, user)

module.exports = new ConversationsController()