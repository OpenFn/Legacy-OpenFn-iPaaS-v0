@controllerModule.controller 'ReleaseNotesController', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.release_notes = []
  
  $http.get('/blog_posts.json').success((data) ->
    $scope.release_notes = data.blog_posts
  )
]
