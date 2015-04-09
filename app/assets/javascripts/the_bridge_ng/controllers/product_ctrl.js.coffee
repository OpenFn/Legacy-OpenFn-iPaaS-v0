@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product = {}
  $scope.searchText = ""

  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data
    $scope.twitterApi = $scope.product.twitter.substring(1)
    $timeout ->
      twttr.widgets.load()
    , 500

  $scope.changeVoteFor = (product) ->
    $http.get("/products/#{product.id}/vote")
      .success (data) ->
        angular.extend(product,data)

      .error (data, status, headers, config) ->
        window.location="/login" if status == 401
        # console.log arguments

  $scope.changeReviewFor = (product) ->
    $http.get("/products/#{product.id}/review")
      .success (data) ->
        angular.extend(product,data)

      .error (data, status, headers, config) ->
        window.location="/login" if status == 401
        # console.log arguments

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchText)
  )

]
