'use strict'
angular.module('smockApp').directive 'notifyFlash', ['$rootScope', '$translate', ($rootScope, $translate)->
  template: '<div class="text-center alert alert-{{level}}" ng-show="msg" ng-click="close()">{{msg}}</div>',
  replace: true
  scope: true
  restrict: 'A'
  link: (scope) ->
    $rootScope.$on 'event:error', (e, msg)->
      scope.level = 'danger'
      scope.msg = msg
      null
    $rootScope.$on 'event:notacceptable', (e, data)->
      scope.level = 'danger'
      scope.msg = ''
      $translate(data.message).then (l)->
        scope.msg += l
      null
    $rootScope.$on 'event:loading', ()->
      scope.level = 'info'
      $translate('loading').then (l)->
        scope.msg = l
      null
    $rootScope.$on 'event:loaded', ->
      setTimeout ->
        scope.$apply ->
          scope.msg = null
          return
        return
      , 200
      null
    $rootScope.$on 'event:ok', (e, msg)->
      scope.level = 'success'
      $translate(msg).then (l)->
        scope.msg = l
      null
    scope.close = ->
      scope.msg = null
      null
    null
]
