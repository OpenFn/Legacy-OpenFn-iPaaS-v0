@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product = {}
  $scope.searchText = ""

  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data
    console.log("product",data)
    $scope.product.reviews_count = $scope.product.reviews.length
    $scope.productRating($scope.product)
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

  $scope.productRating = (product) ->
    $http.get("/product/#{product.id}/rating").success((data) ->
      $scope.product.rating = data
  )

  $scope.upVote = (review) ->
    $http.get("/review/#{review.id}/up_vote")
    review.review_score = review.review_score + 1

  $scope.downVote = (review) ->
    $http.get("/review/#{review.id}/down_vote")
    review.review_score = review.review_score - 1

  $scope.reviewScore = (review,product) ->
    $http.get("/review/#{review.id}/score").success((data) ->
      i = 0
      while i < product.reviews.length
        if product.reviews[i].id == review.id
          $scope.product.reviews[i].review_score = data
        i++
  )
  )
]

