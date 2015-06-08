@controllerModule.controller 'ProductController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product = {}
  $scope.searchText = ""
  $scope.searchTagText = ""

  $http.get('/products/' + $routeParams.id + '.json').success((data) ->
    $scope.product = data

    productTags($scope.product)
    #$scope.twitterApi = $scope.product.twitter.substring(1)
    #$timeout ->
    #  twttr.widgets.load()
    #, 500

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
    $http.get("/tags").success((data) ->
      $scope.tags = data.tags
      #console.log($scope.tags)
     )

  $scope.deleteTag = (tag,product) ->
    index = $scope.product.tag_list.indexOf(tag)
    $scope.product.tag_list.splice(index, 1);

  $scope.addTag = (tag,product) ->
    addToArray = true
    i = 0
    while i < $scope.product.tag_list.length
      if $scope.product.tag_list[i].name == tag.name
        addToArray = false
      i++
    if addToArray
      $scope.product.tag_list.push tag
    console.log($scope.product.tag_list)

  $scope.submitTags = (tags,product) ->
    console.log(product)
    $http.post("/products/#{product.id}/tags/edit",tags).success((data) ->
      console.log(data.tags)
      window.location = data.redirect_url
    )


  $scope.searchTags = (tagText,product) ->
    $scope.tag_match = []
    lowercaseSearchText = angular.lowercase($scope.searchTagText)
    console.log(lowercaseSearchText)
    x = 0
    if (lowercaseSearchText)
      while x < $scope.tags.length
        value = $scope.tags[x].name.search(lowercaseSearchText)
        if (value > -1)
          $scope.tag_match.push $scope.tags[x]
          console.log($scope.tag_match[x])
        x++
      console.log($scope.tag_match)
    else
      $scope.tag_match = []





]
