@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.product = {}
  
  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data
  )
]
