describe "MarketplaceConroller", ->
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
