Controller  = require './base_controller'
User        = require '../models/user'

class UsersController extends Controller

    # POST /users
    create: (req, res) =>
      user = new User({id: @getId()})
      user.save (err) ->
        if err
          res.json Error: err
        else
          res.json {result: "success", user: user}

module.exports = new UsersController()