'use strict'

angular.module('smockApp').factory 'Security', ['$modal', '$location', '$http', '$q', 'Smock', ($modal, $location, $http, $q, Smock)->
  redirect = (url)->
    url = url || '/'
    $location.path url

  service = {
    api: '/api/v1'
    login: (user)->
      $http(method: 'POST', url: Smock.api + '/login', data: user)
    logout: (redirectTo)->
      $http(method: 'DELETE', url: Smock.api + '/logout').then ->
        service.me = null
        redirect redirectTo
    requestCurrentUser: ->
      if service.isAuthenticated()
        $q.when(service.me)
      else
        $http.get(Smock.api + '/me').then (response)->
          service.me = response.data
          service.me
    me: null,
    isAuthenticated: ->
      !!service.me
  }
  service
]
