@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product = {}
  $scope.searchText = ""

  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data

    productTags($scope.product)
    #$scope.twitterApi = $scope.product.twitter.substring(1)
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

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchText)
  )

  productTags = (product) ->
    $http.get("/products/#{product.id}/tags").success((data) ->
      $scope.product.tag_list = data.tags
    )
    $http.get("/tags/").success((data) ->
      $scope.tags = data.tags
      #console.log($scope.tags)
     )

  $scope.deleteTag = (tag,product) ->
    console.log($scope.product.tags.indexOf(tag))
    index = $scope.product.tags.indexOf(tag)
    $scope.product.tags.splice(index, 1);
    #$scope.deleteTagInfo =
    #  'tag_id': tag.id

    #$http.post("/products/#{product.id}/tags/delete",$scope.deleteTagInfo).success((data) ->
    #  console.log(data)
    #  $scope.product.tags = data.tags
    #)

  $scope.submitTags = (tags,product) ->
    console.log(tags)
    $http.post("/products/#{product.id}/tags/edit",tags).success((data) ->
      console.log(data.tags)
      window.location = data.redirect_url

    )

  $scope.searchTags = (tagText,product) ->
    $scope.tag_match = []
    lowercaseSearchText = angular.lowercase($scope.searchText)
    console.log(lowercaseSearchText)
    console.log($scope.tags)
    x = 0
    if (lowercaseSearchText)
      while x < $scope.tags.length
        #console.log($scope.tags[x].name)
        value = $scope.tags[x].name.search(lowercaseSearchText)
        if (value > -1)
          $scope.tag_match[x] = $scope.tags[x]
          console.log($scope.tag_match[x])
        x++
    else
      $scope.tag_match = []
      console.log($scope.tag_match[x])




]
