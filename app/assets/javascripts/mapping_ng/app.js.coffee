'use strict'

Array::filter = (func) -> x for x in @ when func(x)

@mapping = angular.module 'mapping', [
  'mapping.controllers',
  'mapping.directives',
  'mapping.resources',
  'mapping.services',
  'mapping.filters',
  'mapping.config',
  'ngResource',
  'ngRoute',
  'ngAnimate',
  'ui.sortable',
  'ui.bootstrap',
  'ng-rails-csrf',
  'mgcrea.bootstrap.affix'
]

@controllerModule = angular.module 'mapping.controllers', []
@directiveModule  = angular.module 'mapping.directives', []
@resourceModule   = angular.module 'mapping.resources', []
@serviceModule    = angular.module 'mapping.services', []
@filterModule     = angular.module 'mapping.filters', []
@configModule     = angular.module 'mapping.config', []

@mapping.config ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider
    .when '/mappings/:id',
      controller: 'EditMappingCtrl'
      templateUrl: '/ng_templates/mappings/edit.html'
      resolve:
        mappingResponse: ($q, $route, Mapping) ->
          defer = $q.defer()

          # Load the mapping
          Mapping.get(id: $route.current.params.id).$promise.then((response) ->
            defer.resolve response
          )

          defer.promise
