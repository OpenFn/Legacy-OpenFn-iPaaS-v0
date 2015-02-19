@controllerModule.controller 'MarketplaceController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.products = []
  $scope.searchText = ""
  $scope.searchFilters = {}
  
  $http.get('/products.json').success (data) ->
    $scope.products = data.products
    if $routeParams.search
      $scope.searchText = $routeParams.search

  $scope.filterProducts = (product) ->
    
    lowercaseSearchText = angular.lowercase($scope.searchText)
    if (angular.lowercase(product.name).indexOf(lowercaseSearchText)!= -1 || 
      (angular.lowercase(product.description) || "").indexOf(lowercaseSearchText)!= -1 || 
      (angular.lowercase(product.website) || "").indexOf(lowercaseSearchText)!= -1 || 
      tagMatches(product.tag_list, lowercaseSearchText)) &&
      filtersMatch(product, $scope.searchFilters)
        return true
    return false

  tagMatches = (tag_list, text) ->
    if tag_list
      return tag_list.some (tag) ->
        angular.lowercase(tag).indexOf(text) != -1
    else
      false

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
