@controllerModule.controller 'MarketplaceController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.products = []
  $scope.searchText = ""
  $scope.searchFilters = {}
  
  $http.get('/products.json').success((data) ->
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

  $scope.changeVote = (flag, product_id) ->
    html = $('#num_'+product_id).html()
    count = parseInt(html)
    if flag == 'up'
      $('#num_'+product_id).html count + 1
      $('.up_'+product_id).hide()
      $('.down_'+product_id).show()
    else
      $('#num_'+product_id).html count - 1
      $('.up_'+product_id).show()
      $('.down_'+product_id).hide()
    $http.get('/vote/'+product_id)

    return

  )



]
