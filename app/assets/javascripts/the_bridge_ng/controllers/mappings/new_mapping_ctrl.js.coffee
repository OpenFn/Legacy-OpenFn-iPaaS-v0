'use strict'

Legacy.controllers.NewMappingCtrl = ($scope, MappingService, OdkService) ->

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

@controllerModule.controller 'NewMappingCtrl', Legacy.controllers.NewMappingCtrl
