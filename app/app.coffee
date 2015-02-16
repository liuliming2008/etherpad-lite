'use strict'
angular.module('smockApp', [
  'ngAnimate'
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'ngTouch'
  'ui.bootstrap'
  'ui.drop'
  'pascalprecht.translate'
]).config ['$routeProvider', '$locationProvider', '$httpProvider', '$translateProvider', ($routeProvider, $locationProvider, $httpProvider, $translateProvider) ->
  $translateProvider.preferredLanguage 'zh-cn'
  $translateProvider.useStaticFilesLoader {
    prefix: '/i18n/'
    suffix: '.json'
  }
  #$locationProvider.html5Mode(true)
  $routeProvider
    .when '/',
      templateUrl: 'views/cover.html',
      controller: 'HomeCtrl'
    .otherwise
      redirectTo: '/'
  $httpProvider.interceptors.push 'notifyHttpInterceptor'
]
