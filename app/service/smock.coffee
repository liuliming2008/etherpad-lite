'use strict'
angular.module('smockApp').factory 'Smock', ['$http', ($http)->
  smock = {
    api: '/api/v1'
    yesno: {true: 'yes', false: 'no'}
    copyWithDate: (record, field)->
      r= angular.copy(record)
      if typeof(field) == 'string'
        r[field] = new Date(record[field])
      else
        angular.forEach field, (k, v)->
          r[v] = new Date(record[v])
      r
    date2string: (datefield)->
      if datefield
        time = new Date(datefield)
      else
        time = new Date()
      m = (time.getMonth() + 1) + ''
      if m.length == 1
        m = '0' + m
      d = time.getDate() + ''
      if d.length == 1
        d = '0' + d
      time.getFullYear() + '-' + m + '-' + d
    camelcase: (string)->
      string = string.charAt(0).toUpperCase() + string.slice(1)
      string.replace /_(.)/g, (match, group1)->
        group1.toUpperCase()
    fileExist: (url, success)->
      http = new XMLHttpRequest()
      http.open('HEAD', url, false)
      http.send()
      if http.status != 404
        success()
      return
  }
  smock
]
