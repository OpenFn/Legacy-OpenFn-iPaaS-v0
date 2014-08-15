'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope','$rootScope', '$filter',
  'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, $rootScope, $filter, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    $rootScope.loading = true
    $rootScope.itemsLoaded = { odkForms: false, sfForms: false }

    $rootScope.checkIfLoaded = () ->
      if $scope.itemsLoaded.odkForms && $scope.itemsLoaded.sfForms
        $rootScope.loading = false


    ########## VARIABLE ASSIGNMENT

    # mappedObjects = an array of sf objects as read by the mapping service
    #   [
    #     {
    #       name:
    #       label:
    #       ...
    #       // sf fields:
    #       fields: [
    #         {
    #           ...
    #           odk_fields: [ {} ]
    #         }
    #       ]
    #     }
    #   ]
    $scope.mapping = {
      mappingSalesforceObjects: [],
      mappedObjects: []
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

    $scope.randomHexColor = (len=3)->
      pattern = '0123456789ABCDEF'.split ''
      str     = '#'
      for i in [1..len]
        str += pattern[Math.round(Math.random() * pattern.length)]
      str

    ########## WATCHES

    ########## BEFORE FILTERS

]
