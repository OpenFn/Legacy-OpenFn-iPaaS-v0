@controllerModule.controller 'MarketplaceController', ['$scope', '$filter', '$location', '$modal', '$http', '$routeParams', ($scope, $filter, $location, $modal, $http, $routeParams) ->
  $scope.products = []
  $scope.searchText = ""
  $scope.searchFilters = {}
  $scope.isLoading = true
  $scope.tags
  $scope.categories = {};
  $scope.dropdownTags = []
  $scope.tag_count_hash = {};
  $scope.keywords = []

# TODO - These are fetching tag data for the filters bar.
# Note that the filters bar auto-recalculates the remaining "tag matches"
# based on which tags have already been selected.

  $http.get('/tag_categories.json').success((data) ->
    $scope.categories = data;
    )

  $http.get('/tags/get_all_json.json').success((data) ->
    $scope.tags = data;
    i = 0
    while i < $scope.tags.length
      $scope.tag_count_hash[$scope.tags[i].name] = i
      $scope.keywords[i] = $scope.tags[i].name
      i++
    )

  $scope.categoryTags = (category) ->
    $filter('filter')($scope.tags, {tag_category_id: category.id, active: true})

# TODO - This appears to just be here so that you can follow a link in Angular?
# Unclear... is it necessary?

  $scope.go = (url) ->
    $location.path url
    return

# TODO - This is the first gnarly watch.
# It runs after filters are added and removed, but I've noticed a little
# glitchi-ness interacting with packery. http://packery.metafizzy.co/
# When products are filtered, then filters are reset, packery stacks
# products on top of one another!

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

# TODO - This is where "isLoading" gets set to false.
# Right after isLoading is set false, we want this javascript to run.
# If i run it in chrome inspector it 
    # var $container = $('#container');
    # // init
    # $container.packery({
    #   itemSelector: '.item',
    #   gutter: 0
    # });

  $http.get('/products.json').success (data) ->
    $scope.products = data.products
    k = $scope.keywords.length
    j = 0
    while j < $scope.products.length
      $scope.keywords[j + k] = $scope.products[j].name
      j++
    $scope.previousProducts = $scope.products
    $scope.isLoading = false
    # TODO - why doesn't this do the trick?
    # $container = $('#container')
    # $container.packery
    #   itemSelector: '.item'
    #   gutter: 0
    if $routeParams.search
      $scope.searchText = $routeParams.search
    $scope.keywords.reverse()

# TODO - This is probably how we should replace "isLoading", if it's more efficient.
  # angular.element(document).ready ->
  #   console.log 'Hello World'
  #   $container = $('#container')

  $scope.removeTagFilters = ->
    $scope.searchText = ""
    $scope.dropdownTags = []
    $scope.searchFilters.integrated = false
    i = 0
    while i < $scope.tags.length
      $scope.tags[i].active = false
      i++

# TODO, This is to allow the search bar to search all of the info from products.

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


  $scope.showModal = () ->
    modalInstance = $modal.open
      templateUrl: 'modalTemplate.html',
      controller: 'ModalController'


  $scope.changeVoteFor = (product) ->
    url = $location.url()
    $http.get("/user/check_login?redirect=#{url}").success((data) ->
      if data.status == 'login'
        $scope.showModal()
      else
        $http.get("/products/#{product.id}/vote")
          .success (data) ->
            angular.extend(product,data)

          .error (data, status, headers, config) ->
            window.location="/login" if status == 401
      )

  $scope.integratedProduct = (url) ->
    url = "/mappings"
    $http.get("/user/check_login?redirect=#{url}").success((data) ->
      if data.status == 'login'
        $scope.showModal()
      else
        window.location = "/mappings"
    )


]