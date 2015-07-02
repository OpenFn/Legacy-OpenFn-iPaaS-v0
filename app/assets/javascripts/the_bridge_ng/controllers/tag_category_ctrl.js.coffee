@controllerModule.controller 'Tag_CategoryController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
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


]