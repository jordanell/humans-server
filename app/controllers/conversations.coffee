Controller    = require './base_controller'
Conversation  = require '../models/conversation'
User          = require '../models/user'

class ConversationsController extends Controller

    # POST /conversations
    create: (req, res) =>
      unless req.query.user_id
        return res.json err: "Must provide a user id"

      User.random (err, user) =>
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

      Conversation.find {userIds: {$in: [req.query.user_id]}}, (err, conversations) =>
        if err then res.send err

        return res.json {result: "success", conversations: conversations}

    # GET /conversations/:id
    show: (req, res) =>
      unless req.query.user_id
        return res.json err: "Must provide a user id"

      Conversation.findOne { id: req.query.user_id }, (err, conversation) =>
        if err then res.send err

        if !_.contains(conversation.userIds, req.user_id)
          return res.json {err: "Unauthorized access"}

        return res.json {result: "success", conversation: conversation}

module.exports = new ConversationsController()