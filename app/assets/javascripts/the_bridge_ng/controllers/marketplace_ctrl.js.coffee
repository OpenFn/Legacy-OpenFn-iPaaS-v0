@controllerModule.controller 'MarketplaceController', ['$scope', '$location', '$http', '$routeParams', ($scope, $location, $http, $routeParams) ->
  $scope.products = []
  $scope.searchText = ""
  $scope.searchFilters = {}
  $scope.isLoading = true
  $scope.tags
  $scope.categories = {};
  $scope.dropdownTags = []
  $scope.tag_count_hash = {};

  $http.get('/tag_categories.json').success((data) ->
    $scope.categories = data;
    )

  $http.get('/tags/get_all_json.json').success((data) ->
    $scope.tags = data;
    i = 0
    while i < $scope.tags.length
      $scope.tag_count_hash[$scope.tags[i].name] = i
      i++
    )

  $scope.go = (url) ->
    $location.path url
    return

  $scope.taggings_count = (tag) ->
    $http.get("/tag/tagging_count/#{tag.id}").success((data) ->
      tag.tag_count = data
    )

  $scope.$watchCollection 'filteredProducts', ->
    added = []
    removed = []
    if($scope.previousProducts != undefined) && ($scope.filteredProducts != undefined)
      if($scope.previousProducts.length > $scope.filteredProducts.length)
        i = 0
        while (i < $scope.previousProducts.length)
          if($scope.filteredProducts.indexOf($scope.previousProducts[i]) == -1)
            removed.push $scope.previousProducts[i]
          i++
        updateTags(removed, -1)
      else if ($scope.filteredProducts.length > $scope.previousProducts.length)
        i = 0
        while (i < $scope.filteredProducts.length)
          if($scope.previousProducts.indexOf($scope.filteredProducts[i]) == -1)
            added.push $scope.filteredProducts[i]
          i++
        updateTags(added, 1)
    $scope.previousProducts = $scope.filteredProducts
    return

  updateTags = (product_array, int) ->
    i = 0
    while (i < product_array.length)
      j = 0
      while (j < product_array[i].tag_list.length)
        $scope.tags[$scope.tag_count_hash[product_array[i].tag_list[j]]].taggings_count += int
        j++
      i++

  $scope.tagFilter = (tag) ->
    if ($scope.dropdownTags.indexOf tag.name) == -1
      $scope.dropdownTags.push tag.name
    else
      oldDropdownTags = $scope.dropdownTags
      i = 0
      index = $scope.dropdownTags.indexOf tag.name
      $scope.dropdownTags = []
      while i < oldDropdownTags.length
        if i != index
          $scope.dropdownTags.push oldDropdownTags[i]
        i++
  
  $http.get('/products.json').success (data) ->
    $scope.products = data.products
    $scope.previousProducts = $scope.products
    $scope.isLoading = false
    if $routeParams.search
      $scope.searchText = $routeParams.search

  $scope.removeTagFilters = ->
    $scope.searchText = ""
    $scope.dropdownTags = []
    $scope.searchFilters.integrated = false
    i = 0
    while i < $scope.tags.length
      $scope.tags[i].active = false
      i++

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
