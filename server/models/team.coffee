module.exports = (sequelize, DataTypes) ->
  'use strict'
  Team = sequelize.define('Team', { name: DataTypes.STRING },
    classMethods: associate: (models) ->
      Team.hasMany models.User
      return
    engine: 'myisam')
  Team
