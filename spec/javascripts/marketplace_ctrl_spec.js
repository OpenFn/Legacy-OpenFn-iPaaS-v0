describe('MarketplaceController', function() {
  beforeEach(module('the_bridge.controllers'));

  var $controller, location;

  beforeEach(inject(function(_$controller_, _$location_){
    $controller = _$controller_;
    location = _$location_;
  }));

  it("sets the location path", function() {
    var $scope = {$watchCollection: function(){} };
    var controller = $controller('MarketplaceController', {$scope: $scope, $modal: {}, $routeParams: {}});
    $scope.go("/my/url")
    expect(location.path()).toBe("/my/url");
  })
})
