@controllerModule.controller 'TeamController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $http.get('/team_members/get_all').success((data) ->
    $scope.team = data;
  )
]