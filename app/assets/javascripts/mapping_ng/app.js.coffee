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

@mapping.config ($compileProvider, $routeProvider, $locationProvider) ->
  $routeProvider
    .when '/mappings/:id/edit',
      controller: 'MappingCtrl'

    .when '/mappings/new',
      controller: 'MappingCtrl'

  $locationProvider.html5Mode true