module.exports = (sequelize, DataTypes) ->
  'use strict'
  Pad = sequelize.define('Pad', { text: DataTypes.TEXT },
    classMethods: associate: (models) ->
      Pad.belongsTo models.User
      # example on how to add relations
      # Article.hasMany(models.Comments);
      return
    engine: 'myisam')
  Pad
