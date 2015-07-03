@controllerModule.controller 'MarketplaceController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.products = []
  $scope.searchText = ""
  $scope.searchFilters = {}
  $scope.isLoading = true
  $scope.tags
  $scope.categories = {};

  $http.get('/tag_categories.json').success((data) ->
    $scope.categories = data;
    )

  $http.get('/tags/get_all_json.json').success((data) ->
    $scope.tags = data;
    )

  $scope.taggings_count = (tag) ->
    $http.get("/tag/tagging_count/#{tag.id}").success((data) ->
      tag.tag_count = data
    )

  $scope.tagFilter = (tag) ->
    $scope.searchText += tag.name + " "

  $http.get('/products.json').success (data) ->
    $scope.products = data.products
    $scope.isLoading = false
    if $routeParams.search
      $scope.searchText = $routeParams.search

  $scope.filterProducts = (product) ->
    
    lowercaseSearchText = angular.lowercase($scope.searchText)
    all_info = []
    all_info_string = ""

    if (lowercaseSearchText == "")
      return true
    
    lowercaseSearchText = lowercaseSearchText.split(' ')

    if product.tag_list.length == 1
      product.tag_list.push "a tag woo"

    y = 0

    while (y < product.tag_list.length)
      all_info_string += (" " + product.tag_list[y])
      y++

    all_info.push angular.lowercase(product.name)
    all_info.push angular.lowercase(product.description)
    all_info.push angular.lowercase(product.website)
    all_info.push angular.lowercase(all_info_string)
    all_info = all_info.join(' ')
    
    console.log (all_info)

    console.log(lowercaseSearchText)

    x = 0

    while x < lowercaseSearchText.length
      if (all_info.includes(" " + lowercaseSearchText[x]))  
        x++
      else
        break

    if x == (lowercaseSearchText.length)
      return true
    else
      return false


  # tagMatches = (tag_list, text) ->
  #   if tag_list
  #     return tag_list.some (tag) ->
  #       angular.lowercase(tag).indexOf(text) != -1
  #   else
  #     false

  filtersMatch = (product, filters) ->
    
    if filters.integrated
      return product.integrated
    else
      return true

  $scope.changeVoteFor = (product) ->
    $http.get("/products/#{product.id}/vote")
      .success (data) ->
        angular.extend(product,data)
    
      .error (data, status, headers, config) ->
        window.location="/login" if status == 401
        # console.log arguments

]