fs = require('fs')
path = require('path')
Sequelize = require('sequelize')
config = require('../config/config')
db = {}
sequelize = new Sequelize(config.db.database, config.db.user, config.db.password, config.db.options)
fs.readdirSync(__dirname).filter((file) ->
  file.indexOf('.') != 0 and file.indexOf('index') != 0
).forEach (file) ->
  model = sequelize['import'](path.join(__dirname, file))
  db[model.name] = model
  return
Object.keys(db).forEach (modelName) ->
  if 'associate' in db[modelName]
    db[modelName].associate db
  return
db.sequelize = sequelize
db.Sequelize = Sequelize
module.exports = db
