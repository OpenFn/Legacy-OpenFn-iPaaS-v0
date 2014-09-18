'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope','$rootScope', '$filter',
  'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService', 'OdkService'
  ($scope, $rootScope, $filter, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService, OdkService) ->

    $rootScope.loading = true
    $rootScope.itemsLoaded = { odkForms: false, sfForms: false }

    $rootScope.checkIfLoaded = () ->
      if $scope.itemsLoaded.odkForms# && $scope.itemsLoaded.sfForms
        $rootScope.loading = false

    ########## VARIABLE ASSIGNMENT

    $scope.mapping = {}

    $scope.colors = [
      "#F7977A", "#F9AD81", "#FDC68A", "#FFF79A", "#8493CA", "#8882BE", "#A187BE", "#BC8DBF",
      "#F49AC2", "#F6989D", "#C4DF9B", "#A2D39C", "#82CA9D", "#7BCDC8", "#6ECFF6", "#7EA7D8"
    ]

    ########## FUNCTIONS

    # This is called on the edit view
    $scope.init = (mappingId) ->
      # flag that we're editing
      $scope.editMode = true

      # Load the mapping
      Mapping.get(id: mappingId).$promise.then((response) ->

        # Reverse the mapping into the format needed to display in the view
        $scope.mapping = response.mapping

        # remove colors already used
        for sfObject in $scope.mapping.mappedSfObjects
          index = $scope.colors.indexOf(sfObject.color)
          $scope.colors.splice(index, 1) if index != -1
      )


    $scope.saveMapping = ->
      MappingService.saveMapping(angular.copy($scope.mapping)).$promise.
        then(
          (response) ->
            window.location = "/mappings/#{response.mapping.id}"
          (error_response) ->
            $scope.errors = error_response.data.errors
        )

    $scope.randomHexColor = (len=3)->
      pattern = '0123456789ABCDEF'.split ''
      str     = '#'
      for i in [1..len]
        str += pattern[Math.round(Math.random() * pattern.length)]
      str

    ########## WATCHES

    ########## BEFORE FILTERS

]
