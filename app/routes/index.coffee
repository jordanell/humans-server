express = require 'express'
Router  = require './router'

# Possible actions for resources: index, create, show, destroy, update
# Usage: Router.resource <path>, {controller: <name>, only: <[action]>}

module.exports = (router) ->
  router = express.Router()
  Router.router = router

  ##################################
  ############ Users ###############
  ##################################

  Router.resource 'users', controller: 'users', only: [create]

  return router