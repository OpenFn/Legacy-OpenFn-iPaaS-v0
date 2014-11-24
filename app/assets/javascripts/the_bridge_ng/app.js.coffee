'use strict'

Array::filter = (func) -> x for x in @ when func(x)

@the_bridge = angular.module('the_bridge', [
  'ngRoute',
  'ngResource',
  'ui.tree',
  'ngAnimate',
  'the_bridge.controllers',
  'the_bridge.directives',
  'the_bridge.resources',
  'the_bridge.services',
  'the_bridge.filters',
  'the_bridge.config',
  'ui.sortable',
  'ui.bootstrap',
  'ng-rails-csrf',
  'mgcrea.bootstrap.affix'
 ])

@controllerModule = angular.module 'the_bridge.controllers', []
@directiveModule  = angular.module 'the_bridge.directives', []
@resourceModule   = angular.module 'the_bridge.resources', []
@serviceModule    = angular.module 'the_bridge.services', []
@filterModule     = angular.module 'the_bridge.filters', []
@configModule     = angular.module 'the_bridge.config', []

@the_bridge.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider
    .when '/mappings/new',
      controller: 'NewMappingCtrl'
      templateUrl: '../the_bridge_templates/mappings/new.html'

    .when '/mappings/:id',
      controller: 'EditMappingCtrl'
      templateUrl: '../the_bridge_templates/mappings/edit.html'
      resolve:
        mappingResponse: ($q, $route, Mapping) ->
          defer = $q.defer()

          # Load the mapping
          Mapping.get(id: $route.current.params.id).$promise.then((response) ->
            defer.resolve response
          )

          defer.promise
    .when('/metrics/organisation', {
      templateUrl: '../the_bridge_templates/metrics/organisations/index.html',
      controller: 'OrganisationsIndexCtrl'
    })
    .when('/marketplace', {
      templateUrl: '../the_bridge_templates/marketplace/index.html',
    })
    .when('/marketplace/search/:search', {
      templateUrl: '../the_bridge_templates/marketplace/index.html',
    })
    .when('/marketplace/search/', {
      templateUrl: '../the_bridge_templates/marketplace/index.html',
    })
    .when('/product/:id', {
      templateUrl: '../the_bridge_templates/product/show.html',
    })
    .when('/release-notes', {
      templateUrl: '../the_bridge_templates/static/release-notes.html'
    })
    .when('/welcome', {
      templateUrl: '../the_bridge_templates/static/welcome.html'
    })
    .when('/', {
      templateUrl: '../the_bridge_templates/static/welcome.html',
      redirectTo: (current, path, search) ->
        if(search.goto)
          return "/" + search.goto
        else
          return "/" })
    .otherwise({redirectTo:"/"})