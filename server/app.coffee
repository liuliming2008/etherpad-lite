express = require('express')
config = require('./config/config')
db = require('./models')

app = express()

require('./config/express')(app, config)

db.sequelize.sync().then( ->
  app.listen(config.port)
).catch((e)->
  throw new Error(e)
)
