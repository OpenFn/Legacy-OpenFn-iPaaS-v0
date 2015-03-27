@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.product = {}
  $scope.searchText = ""
  
  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data
    $scope.twitterApi = $scope.product.twitter.substring(1)
    twttr.widgets.load()

  $scope.changeVoteFor = (product) ->
    $http.get("/products/#{product.id}/vote")
      .success (data) ->
        angular.extend(product,data)
    
      .error (data, status, headers, config) ->
        window.location="/login" if status == 401
        # console.log arguments

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchText)
  )

]
