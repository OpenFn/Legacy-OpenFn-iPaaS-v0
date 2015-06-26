@controllerModule.controller 'AdminController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->

  $http.get("/admin/drafts").success((data) ->
    $scope.drafts = data.drafts
    console.log("drafts",$scope.drafts)
  )

  $scope.publish = (draft) ->
    $http.put("/admin/drafts/#{draft.id}").success((data) ->
      $http.get("/admin/drafts").success((data) ->
        $scope.drafts = data.drafts
      )
    )

  $scope.discard = (draft) ->
    $http.delete("/admin/drafts/#{draft.id}").success((data) ->
      $http.get("/admin/drafts").success((data) ->
        $scope.drafts = data.drafts
      )
    )
]
