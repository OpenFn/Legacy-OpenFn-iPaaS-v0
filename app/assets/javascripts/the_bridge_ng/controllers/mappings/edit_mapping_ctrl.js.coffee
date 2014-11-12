'use strict'

@controllerModule.controller 'EditMappingCtrl', ['$scope', '$timeout', 'mappingResponse', 'Mapping',
  ($scope, $timeout, mappingResponse, Mapping) ->

    ########## VARIABLE ASSIGNMENT

    # Reverse the mapping into the format needed to display in the view
    $scope.mapping = mappingResponse.mapping
    $scope.salesforceObjects = mappingResponse.salesforceObjects
    $scope.odkFilter = {}

    ########## FUNCTIONS

    $scope.onAffix = ->
      angular.element('.odk-row').css('marginTop', '350px')

    $scope.onUnaffix = ->
      angular.element('.odk-row').css('marginTop', '0px')

    $scope.saveMapping = ->
      if $scope.saveFunc
        $timeout.cancel $scope.saveFunc

      $scope.saveFunc = $timeout () ->
        Mapping.update(
          id: $scope.mapping.id
          name: $scope.mapping.name
          active: $scope.mapping.active
        ).$promise.then ->
          $scope.$broadcast "mapping:saved"
      , 1000

    ########## WATCHES

    $scope.$on "mapping:saved", ->
      $scope.saved = true
      $timeout () ->
        $scope.saved = false
      , 2000

    ########## BEFORE FILTERS

]