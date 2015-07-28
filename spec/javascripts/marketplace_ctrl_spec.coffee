describe "MarketplaceController", ->
  beforeEach(module 'the_bridge.controllers')

  $controller = null
  location = null

  beforeEach(inject((_$controller_, _$location_) ->
    $controller = _$controller_
    location = _$location_
  ))

  it "sets the location path", ->
    $scope = {$watchCollection: -> }
    controller = $controller('MarketplaceController', {$scope: $scope, $modal: {}, $routeParams: {}})
    $scope.go "/my/url"
    expect(location.path()).toBe("/my/url")

  it "filters products, part the first", ->
    $scope = {
      $watchCollection: ->,
    }
    product = {
      name: "foo",
      description: "bar",
      website: "baz",
      tag_list: [ "ringo", "paul", "john", "george"]
    }
    controller = $controller('MarketplaceController', {$scope: $scope, $modal: {}, $routeParams: {}})

    # searchText gets cleared upon controller initialisation  
    $scope.searchText = "foo bar baz ringo paul john george"

    expect($scope.filterProducts(product)).toBe(true)
