'use strict'

@controllerModule.controller 'EditMappingCtrl', ['$scope', 'Mapping',
  ($scope, Mapping) ->

    ########## VARIABLE ASSIGNMENT

    $scope.mapping = {}
    $scope.odkFilter = {}

    ########## FUNCTIONS

    # This is called on the edit view
    $scope.init = (mappingId) ->

      # Load the mapping
      Mapping.get(id: mappingId).$promise.then((response) ->

        # Reverse the mapping into the format needed to display in the view
        $scope.mapping = response.mapping
        $scope.salesforceObjects = response.salesforceObjects
      )

    $scope.onAffix = ->
      angular.element('.odk-row').css('marginTop', angular.element('.sf-row').outerHeight() + 115 + 'px')

    $scope.onUnaffix = ->
      angular.element('.odk-row').css('marginTop', '0px')

    ########## WATCHES

    ########## BEFORE FILTERS

]