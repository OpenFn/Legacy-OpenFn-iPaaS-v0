'use strict'

OpenFn.Mappings = angular.module 'OpenFn.Mappings', ['ui.bootstrap']

OpenFn.Mappings.config [
  '$routeProvider',
  '$locationProvider',
  ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode true

    if Features.new_mapping_page
      $routeProvider
      .when '/mappings/new',
        templateUrl: '/templates/loading.html'
        controller: 'NewMappingCtrl'

      .when '/mappings/:id/edit',
        templateUrl: '/templates/mappings.html'
        controller: 'MappingViewCtrl as mappingCtrl'
        resolve:
          mappingId: ($q, $route) ->
            $q (resolve) -> resolve($route.current.params.id)
]

