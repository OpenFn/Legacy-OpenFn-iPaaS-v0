'use strict'

@controllerModule.controller 'NewMappingCtrl', ['$scope', 'MappingService', 'OdkService',
  ($scope, MappingService, OdkService) ->

    ########## VARIABLE ASSIGNMENT

    $scope.mapping = {}

    ########## FUNCTIONS

    $scope.loadOdkForms = ->
      OdkService.loadForms (forms) ->
        $scope.odkForms = forms

    $scope.createMapping = ->
      MappingService.saveMapping($scope.mapping).$promise.then(
        (response) ->
          window.location = "/mappings/#{response.mapping.id}"
        (error_response) ->
          $scope.errors = error_response.data.errors
      )

    ########## WATCHES

    ########## BEFORE FILTERS

    $scope.loadOdkForms()

]