'use strict'

@mapping = angular.module 'mapping', [
  'mapping.controllers',
  'mapping.directives',
  'mapping.resources',
  'mapping.services',
  'mapping.filters',
  'mapping.config',
  'ngResource',
  'ui.sortable'
]

@controllerModule = angular.module 'mapping.controllers', []
@directiveModule  = angular.module 'mapping.directives', []
@resourceModule   = angular.module 'mapping.resources', []
@serviceModule    = angular.module 'mapping.services', []
@filterModule     = angular.module 'mapping.filters', []
@configModule     = angular.module 'mapping.config', []