@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.product = {}
  $scope.searchText = ""
  
  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchText)
  )
]
