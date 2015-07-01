@controllerModule.controller 'Tag_CategoryController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tags

  $http.get('/tag_categories.json').success((data) ->
    $scope.tags = data;
    )




]