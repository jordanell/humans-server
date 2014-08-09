Controller  = require './base_controller'
uuid        = require 'uuid'
User        = require '../models/user'

class UsersController extends Controller

    # POST /users
    create: (req, res) ->
      user = new User({id: uuid.v4()})
      user.save (err) ->
        if err
          res.json Error: err
        else
          res.json {result: "success", user: user}

module.exports = new UsersController()