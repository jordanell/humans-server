// Generated by CoffeeScript 1.8.0
var Controller, Conversation, ConversationsController, Message, User, _,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Controller = require('./base_controller');

Conversation = require('../models/conversation');

User = require('../models/user');

Message = require('../models/message');

_ = require('underscore');

ConversationsController = (function(_super) {
  __extends(ConversationsController, _super);

  function ConversationsController() {
    this.getRandomUser = __bind(this.getRandomUser, this);
    this.leave = __bind(this.leave, this);
    this.show = __bind(this.show, this);
    this.index = __bind(this.index, this);
    this.create = __bind(this.create, this);
    return ConversationsController.__super__.constructor.apply(this, arguments);
  }

  ConversationsController.prototype.create = function(req, res) {
    if (!req.query.user_id) {
      return res.json({
        err: "Must provide a user id"
      });
    }
    return this.getRandomUser(req.query.user_id, (function(_this) {
      return function(err, user) {
        var conversation, time, userIds;
        if (user === null) {
          return res.json({
            err: "Could not find a user"
          });
        }
        userIds = [user.id, req.query.user_id];
        time = Date();
        conversation = new Conversation({
          id: _this.getId(),
          userIds: userIds,
          name: user.name,
          created: time,
          updated: time
        });
        return conversation.save(function(err) {
          if (err) {
            return res.send(err);
          } else {
            return res.json({
              result: "success",
              conversation: conversation
            });
          }
        });
      };
    })(this));
  };

  ConversationsController.prototype.index = function(req, res) {
    if (!req.query.user_id) {
      return res.json({
        err: "Must provide a user id"
      });
    }
    if (!req.query.page) {
      req.query.page = 1;
    }
    return Conversation.find({
      userIds: {
        $in: [req.query.user_id]
      }
    }, null, {
      sort: {
        updated: -1
      },
      skip: (req.query.page - 1) * this.PAGE_SIZE,
      limit: this.PAGE_SIZE
    }, (function(_this) {
      return function(err, conversations) {
        if (err) {
          res.send(err);
        }
        return res.json({
          result: "success",
          conversations: conversations
        });
      };
    })(this));
  };

  ConversationsController.prototype.show = function(req, res) {
    if (!req.query.user_id) {
      return res.json({
        err: "Must provide a user id"
      });
    }
    return Conversation.findOne({
      id: req.query.conversation_id
    }, (function(_this) {
      return function(err, conversation) {
        if (err) {
          res.send(err);
        }
        if (!_.contains(conversation.userIds, req.query.user_id)) {
          return res.json({
            err: "Unauthorized access"
          });
        }
        return res.json({
          result: "success",
          conversation: conversation
        });
      };
    })(this));
  };

  ConversationsController.prototype.leave = function(req, res) {
    if (!req.query.user_id) {
      return res.json({
        err: "Must provide a user id"
      });
    }
    return Conversation.findOne({
      id: req.query.conversation_id
    }, (function(_this) {
      return function(err, conversation) {
        var message;
        if (err) {
          res.send(err);
        }
        if (!_.contains(conversation.userIds, req.query.user_id)) {
          return res.json({
            err: "Unauthorized access"
          });
        }
        conversation.userIds = _.without(conversation.userIds, req.query.user_id);
        message = new Message({
          id: _this.getId(),
          body: "The other human has left this conversation",
          userId: req.query.user_id,
          conversationId: req.query.conversation_id,
          created: Date()
        });
        message.save(function() {});
        return conversation.save(function(err) {
          if (err) {
            return res.send(err);
          }
          return res.json({
            result: "success",
            message: "Removed from conversation"
          });
        });
      };
    })(this));
  };

  ConversationsController.prototype.getRandomUser = function(userId, cb, level) {
    if (level == null) {
      level = 0;
    }
    if (level >= 5) {
      return cb({
        err: "Could not find user"
      }, null);
    }
    return User.random((function(_this) {
      return function(err, user) {
        if (err) {
          return cb({
            err: "Could not find user"
          }, null);
        }
        if (user.id === userId) {
          return _this.getRandomUser(userId, cb, level + 1);
        }
        return cb(null, user);
      };
    })(this));
  };

  return ConversationsController;

})(Controller);

module.exports = new ConversationsController();
