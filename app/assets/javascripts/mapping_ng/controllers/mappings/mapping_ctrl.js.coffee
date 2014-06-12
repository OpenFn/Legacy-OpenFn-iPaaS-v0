'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope', '$filter', 'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, $filter, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    ########## VARIABLE ASSIGNMENT

    $scope.mapping = {
      mappingSalesforceObjects: []
    }

    ########## FUNCTIONS

    # This is called on the edit view
    $scope.init = (mappingId) ->
      # flag that we're editing
      $scope.editMode = true

      # Load the mapping
      Mapping.get(id: mappingId).$promise.then((response) ->

        # Reverse the mapping into the format needed to display in the view
        $scope.mapping = MappingService.reverseMapping(response.mapping)
      )

    $scope.saveMapping = ->
      MappingService.saveMapping($scope.mapping).$promise.
        then(
          (response) ->
            window.location = "/mappings/#{response.mapping.id}"
          (error_response) ->
            $scope.errors = error_response.data.errors
        )

    ########## WATCHES

    ########## BEFORE FILTERS

]