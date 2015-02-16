'use strict'
angular.module('smockApp').controller 'MainCtrl', ['Security', '$scope', '$rootScope', '$modal', (Security, $scope, $rootScope, $modal)->
  $scope.$on 'event:unauthorized', ->
    if !Security.modal
      Security.showLogin()
  $scope.$on 'event:authorized', (e, me)->
    $scope.me = me
    me

  $scope.$on 'event:title', (e, title)->
    $scope.title = title

  Security.requestCurrentUser().then (me)->
    $rootScope.$broadcast 'event:authorized'
    $scope.me = me
    me

  $scope.login = ->
    $http(method: 'POST', url: '/login', data: user)

  $scope.logout = ->
    $http(method: 'GET', url: '/logout').then ->
      $location.path '/'
    $rootScope.$broadcast 'event:logout'
    $scope.me = null
    null

  $scope.showLogin = ->
    Security.showLogin()

  $scope.editPassword = ->
    $modal.open {
      templateUrl: '/views/editPassword.html'
      controller: 'UserCtrl'
      resolve:
        me: ->
          $scope.me
    }
    return

  null
]
