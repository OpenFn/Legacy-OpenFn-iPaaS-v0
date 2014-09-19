'use strict'

@controllerModule.controller 'EditMappingCtrl', ['$scope', 'Mapping',
  ($scope, Mapping) ->

    ########## VARIABLE ASSIGNMENT

    $scope.mapping = {}

    ########## FUNCTIONS

    # This is called on the edit view
    $scope.init = (mappingId) ->

      # Load the mapping
      Mapping.get(id: mappingId).$promise.then((response) ->

        # Reverse the mapping into the format needed to display in the view
        $scope.mapping = response.mapping
      )

    ########## WATCHES

    ########## BEFORE FILTERS

]