express = require('express')
glob = require('glob')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
session = require('cookie-session')
bodyParser = require('body-parser')
compress = require('compression')
methodOverride = require('method-override')

module.exports = (app, config) ->
  app.set 'views', config.root + '/views'
  app.set 'view engine', 'jade'
  # app.use(favicon(config.root + '/public/img/favicon.ico'));
  env = app.get('env')
  #if env == 'development'
  #  app.use logger('dev')
  #else if env == 'production'
  fs = require('fs')
  path = require('path')
  logStream = fs.createWriteStream(path.resolve(__dirname + '/../../log/smock.log'), flags: 'a')
  app.use logger('combined', stream: logStream)
  app.use bodyParser.json()
  app.use bodyParser.urlencoded(extended: true)
  app.use cookieParser()
  app.use session({
    name: 'somck-sessionid'
    keys: config.session.keys
    secret: config.session.secret
  })
  app.use compress()
  app.use express.static(config.root + '/../public')
  app.use methodOverride()
  controllers = glob.sync(config.root + '/controllers/*.coffee')
  controllers.forEach (controller) ->
    require(controller) app
    return
  app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next err
    return
  if env == 'development'
    app.use (err, req, res, next) ->
      res.status err.status or 500
      res.json
        message: err.message
        error: err
        title: 'error'
      return
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.json
      message: err.message
      error: {}
      title: 'error'
    return
  return
