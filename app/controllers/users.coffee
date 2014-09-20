Controller  = require './base_controller'
User        = require '../models/user'

class UsersController extends Controller

    # POST /users
    create: (req, res) =>
      user = new User({id: @getId(), name: 'Anonymous'})
      user.save (err) ->
        if err
          res.json Error: err
        else
          res.json {result: "success", user: user}

    # PUT /users
    update: (req, res) =>
      User.findOne { id: req.param('user_id') }, (err, user) =>
        if err then res.send err

        user.name = req.param('name')

        user.save (err) =>
          if err then return res.send err
          res.json {result: "success", user: user}

module.exports = new UsersController()