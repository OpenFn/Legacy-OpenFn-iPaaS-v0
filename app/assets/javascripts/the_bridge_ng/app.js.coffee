@the_bridge = angular.module('the_bridge', ['ngRoute', 'ngResource'])

@the_bridge.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    otherwise({
      templateUrl: '../the_bridge_templates/home/index.html',
      controller: 'HomeController'
    }) 
])