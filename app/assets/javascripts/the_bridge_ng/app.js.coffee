# Currently two angular instances exist, 'the_bridge' and 'mappings'. 
# 'mappings' will need to move into 'the_bridge' so that we don't do full page
# loads for every menu item.
# 'the_bridge' does not use the rails layout, and is loaded directly from metrics#index.
# We want to move towards a full Angular implementation, and reduce Rails to only a json api.
# We're trying to break our dependence on Rails view rendering, and make 'the_bridge'
# the canonical in-browser app, which will eventually include mappings and the hub.
@the_bridge = angular.module('the_bridge', ['ngRoute', 'ngResource', 'ui.tree'])

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
