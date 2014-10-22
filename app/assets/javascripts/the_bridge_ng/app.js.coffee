# register the app
@the_bridge = angular.module('the_bridge', ['ngRoute', 'ngResource', 'ui.tree'])

# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
@the_bridge.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/metrics/organisation', {
      templateUrl: '../the_bridge_templates/metrics/organisations/index.html',
      controller: 'OrganisationsIndexCtrl'
    }).
    otherwise({
      templateUrl: '../the_bridge_templates/metrics/organisations/index.html',
      controller: 'OrganisationsIndexCtrl'
    }) 
])
