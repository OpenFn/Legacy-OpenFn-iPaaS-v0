@the_bridge.controller 'ProductSearchController', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.products = []
  $scope.searchText = ""
  
  $http.get('./products.json').success((data) ->
    $scope.products = data.products
  )

  $scope.filterProducts = (product) ->
    if (angular.lowercase(product.name).indexOf(angular.lowercase($scope.searchText))!=-1 || (angular.lowercase(product.description) || "").indexOf(angular.lowercase($scope.searchText))!=-1)
      return true
    return false
]
