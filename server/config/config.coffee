path = require('path')
rootPath = path.normalize(__dirname + '/..')
env = process.env.NODE_ENV or 'development'
config =
  env: env
  development:
    smtp:
      host: 'mail.chgb.org.cn'
      from: 'wangfan@chgb.org.cn'
      user: 'wangfan@chgb.org.cn'
      pass: 'sinofan'
      secureConnection: false
      port: 25
    session:
      secrect: 'xxxxxxxxxxxx'
      keys: ['key2', 'key1']
    root: rootPath
    app: name: 'smock'
    port: 3000
    db:
      database: 'smock'
      user: 'root'
      password: '1'
      options:
        host: 'localhost'
        dialect: 'mysql'
        pool:
          max: 5
          min: 1
          idle: 1000
  test:
    session:
      secrect: 'test'
      keys: ['key2', 'key1']
    root: rootPath
    app: name: 'smock'
    port: 3000
    db: 'mysql://localhost/smock-test'
  production:
    session:
      secrect: ''
      keys: ['key2', 'key1']
    root: rootPath
    app: name: 'smock'
    port: 3000
    db: 'mysql://localhost/smock'
module.exports = config[env]
