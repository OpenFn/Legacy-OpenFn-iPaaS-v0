@controllerModule.controller 'TagController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""

  $http.get('/tags/get_all').success((data) ->
    $scope.tags = data.tags;
    $scope.tag_match = $scope.tags
    $scope.tags_duplicate = angular.copy($scope.tags)
    console.log("data :"+JSON.stringify($scope.tags_duplicate))
  )

  $scope.searchTags = (tagText) ->
    $scope.tag_match = []
    lowercaseSearchText = angular.lowercase($scope.searchTagText)
    x = 0
    if (lowercaseSearchText)
      while x < $scope.tags_duplicate.length
        value = $scope.tags_duplicate[x].name.toLowerCase().search(lowercaseSearchText)
        if (value > -1)
          $scope.tag_match.push $scope.tags_duplicate[x]
        x++
    else
      $scope.tag_match = $scope.tags_duplicate

  $scope.searchAgain = () ->
    $location.path('/marketplace/search/' + $scope.searchTagText)

  $scope.tagging_count = (tag) ->
    $http.get("/tag/tagging_count/#{tag.id}").success((data) ->
      i = 0
      while i < $scope.tag_match.length
        if $scope.tag_match[i].id == tag.id
          $scope.tag_match[i].tag_count = data
        i++
    )
]