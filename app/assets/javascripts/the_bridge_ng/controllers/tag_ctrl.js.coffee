@controllerModule.controller 'TagController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""

  $http.get('/tags').success((data) ->
    $scope.tags = data.tags;
    console.log("data :"+JSON.stringify(data));

  $scope.searchTags = () ->
    console.log("InSearchText");

  )
]


