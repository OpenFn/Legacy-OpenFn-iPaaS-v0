@the_bridge.controller 'OrganisationsIndexCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.organisationMappings = []
  $http.get('/metrics/organisation_integration_mappings.json').success((data) ->
    $scope.organisationIntegrationMappings = data
  )
    
]