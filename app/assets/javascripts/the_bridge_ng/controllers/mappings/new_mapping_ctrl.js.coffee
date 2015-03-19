'use strict'

Legacy.controllers.NewMappingCtrl = ['$scope', 'MappingService', 'OdkService',
  ($scope, MappingService, OdkService) ->

    ########## VARIABLE ASSIGNMENT

    $scope.mapping = {
      odkForm: {}
    }

    ########## FUNCTIONS

    $scope.loadOdkForms = ->
      OdkService.loadForms (forms) ->
        $scope.odkForms = forms

    $scope.createMapping = ->
      $scope.isCreating = true
      MappingService.saveMapping($scope.mapping).$promise.then(
        (response) ->
          window.location = "/mappings/#{response.id}"
        (error_response) ->
          $scope.errors = error_response.data.errors
          $scope.isCreating = false
      )

    ########## WATCHES

    ########## BEFORE FILTERS

    $scope.loadOdkForms()
]

# Trying out working around angulars module system, namespacing doesn't
# work as expected. So I've commented this out to see if I can get away with
# using vars as dependencies.
#@controllerModule.controller 'NewMappingCtrl', Legacy.controllers.NewMappingCtrl
