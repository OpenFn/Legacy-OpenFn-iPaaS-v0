@controllerModule.controller 'MarketplaceController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.products = []
  $scope.searchText = ""
  $scope.searchFilters = {}
  $scope.isLoading = true
  $scope.tags
  $scope.categories = {};
  $scope.dropdownTags = []

  $http.get('/tag_categories.json').success((data) ->
    $scope.categories = data;
    )

  $http.get('/tags/get_all_json.json').success((data) ->
    $scope.tags = data;
    )

  $scope.go = (url) ->
    $location.path url
    return

  $scope.taggings_count = (tag) ->
    $http.get("/tag/tagging_count/#{tag.id}").success((data) ->
      tag.tag_count = data
    )

  $scope.tagFilter = (tag) ->

      if ($scope.dropdownTags.indexOf tag.name) == -1
        $scope.dropdownTags.push tag.name
      else
        $scope.dropdownTags.splice $scope.dropdownTags.indexOf(tag.name, 1)

      if tag.tag_count == 0
        return false
      else
        return true
  
  $http.get('/products.json').success (data) ->
    $scope.products = data.products
    $scope.isLoading = false
    if $routeParams.search
      $scope.searchText = $routeParams.search

  $scope.filterProducts = (product) ->
    
    lowercaseSearchText = angular.lowercase ($scope.searchText)
    all_info = []
    all_info_string = ""
    
    lowercaseSearchText = lowercaseSearchText.split(' ')

    y = 0

    while (y < product.tag_list.length)
      all_info_string += (" " + product.tag_list[y])
      y++

    all_info.push angular.lowercase(product.name)
    all_info.push angular.lowercase(product.description)
    all_info.push angular.lowercase(product.website)
    all_info.push angular.lowercase(all_info_string)
    all_info = all_info.join(' ')

    x = 0

    while x < lowercaseSearchText.length
      if ((all_info.indexOf(lowercaseSearchText[x])!= -1) && filtersMatch(product, $scope.searchFilters) && (dropdownTagsMatch($scope.dropdownTags, product.tag_list)))  
        x++
      else
        break

    updateTags()
    console.log("just updated")
    if x == (lowercaseSearchText.length)
      updateTags()
      return true
    else
      updateTags()
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

  updateTags = ->
    i = 0
    while i < $scope.tags.length
      $scope.tags[i].tag_count = 0
      j = 0
      while j < $scope.filteredProducts.length
        k = 0
        while k < $scope.filteredProducts[j].tag_list.length
          if $scope.tags[i].name == $scope.filteredProducts[j].tag_list[k]
            $scope.tags[i].tag_count += 1
          k++
        j++
      i++


  dropdownTagsMatch = (dropdownTagsasFilters, scopetags) ->

    for i in [0...dropdownTagsasFilters.length]
      if($.inArray(dropdownTagsasFilters[i], scopetags) == -1) 
        return false
    return true
  
  $scope.changeVoteFor = (product) ->
    $http.get("/products/#{product.id}/vote")
      .success (data) ->
        angular.extend(product,data)
    
      .error (data, status, headers, config) ->
        window.location="/login" if status == 401

]