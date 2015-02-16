'use strict'
angular.module('smockApp').controller 'HomeCtrl', ['$scope', '$http', '$location', 'Smock', ($scope, $http, $location, Smock) ->
  $scope.user = {
    email: ''
    team: ''
  }

  $scope.signup = ->
    $http(method: 'POST', url: Smock.api + '/signup', data: $scope.user).then (user)->
      console.log user.data
      $location.path = '/receivemail'
      return
    return

  return
]
