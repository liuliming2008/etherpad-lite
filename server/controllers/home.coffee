mailer = require('express-mailer')
config = require('../config/config')
express = require('express')
router = express.Router()
db = require('../models')
fs = require('fs')
path = require('path')
maillog = path.resolve(__dirname + '/../../log/registermail.log')

expressapp = null

module.exports = (app) ->
  expressapp = app
  app.use '/api/v1', router
  smtp = config.smtp
  mailer.extend app, {
    from: smtp.user
    host: smtp.host
    port: smtp.port
    transportMethod: 'SMTP'
    secureConnection: smtp.secureConnection
    auth: {
      user: smtp.user
      pass: smtp.pass
    }
  }
  return

router.post '/signup', (req, res, next) ->
  email = req.body.email.toLowerCase().trim()
  if email == ''
    res.status(406).json {
      message: 'need_email'
    }
    return
  db.User.findOrCreate({where: {email: email}}).spread((user, created) ->
    user.updateAttributes team: req.body.team
    req.session.email = email

    # send register email
    expressapp.mailer.send('registerEmail', {
      to: email
      subject: 'welcome to smock'
    }, (err)->
      if err
        fs.writeFile(maillog, new Date() + ' error when sending mail to ' + email + "\n", {flag: 'a'})
      else
        fs.writeFile(maillog, new Date() + ' mail sent to ' + email + "\n", {flag: 'a'})
    )
    res.json {
      created: created
      email: email
      signed: !created
    }
    return
  ).catch((error)->
    res.status(406).json error
  )
  return

router.get '/receivemail', (req, res, next) ->
  res.render 'signin', {
    email: req.session.email
    signed: req.session.signed
  }
  return
