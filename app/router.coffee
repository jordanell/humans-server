module.exports = (router) ->

  ##################################
  ############ Users ###############
  ##################################

  router.route '/users'
    .post require('./controllers/users').create