module.exports = (sequelize, DataTypes) ->
  'use strict'
  User = sequelize.define('User', {
    email: {
      type: DataTypes.STRING
      validate: {
        isEmail: true
      }
    }
    name: DataTypes.STRING
    password: DataTypes.STRING
    team: DataTypes.STRING
    team_id: DataTypes.INTEGER
  }, {
    classMethods: associate: (models) ->
      User.hasMany models.Pad
      User.belongsTo models.Team
      return
    engine: 'myisam'
  })
  User
