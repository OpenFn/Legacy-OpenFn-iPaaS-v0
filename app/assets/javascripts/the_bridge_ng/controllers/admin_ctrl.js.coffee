@controllerModule.controller 'AdminController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product_drafts = []
  $scope.tagging_drafts = []

  $http.get("/admin/drafts").success((data) ->
    i = 0
    while i < data.drafts.length
      if data.drafts[i].item_type == "Product"
        $scope.product_drafts.push data.drafts[i]
        i++
      if data.drafts[i].item_type == "Tagging"
        $scope.tagging_drafts.push data.drafts[i]
        i++

    console.log("drafts",$scope.drafts)
  )

  $scope.publish = (draft) ->
    $http.put("/admin/drafts/#{draft.id}").success((data) ->
      $http.get("/admin/drafts").success((data) ->
        $scope.product_drafts = []
        i = 0
        while i < data.drafts.length
          if data.drafts[i].item_type == "Product"
            $scope.product_drafts.push data.drafts[i]
          i++
      )
    )

  $scope.discard = (draft) ->
    $http.delete("/admin/drafts/#{draft.id}").success((data) ->
      $http.get("/admin/drafts").success((data) ->
        $scope.product_drafts = []
        i = 0
        while i < data.drafts.length
          if data.drafts[i].item_type == "Product"
            $scope.product_drafts.push data.drafts[i]
          i++
      )
    )
  $scope.tagging_publish = (draft) ->
    $http.get("/tags/publish/#{draft.id}", {params: {selection: "publish"}}).success((data) ->
      $http.get("/admin/drafts").success((data) ->
        $scope.tagging_drafts = []
        i = 0
        while i < data.drafts.length
          if data.drafts[i].item_type == "Tagging"
            $scope.tagging_drafts.push data.drafts[i]
          i++
      )
    )

  $scope.tagging_discard = (draft) ->
    $http.get("/tags/publish/#{draft.id}", {params: {selection: "discard"}}).success((data) ->
      $http.get("/admin/drafts").success((data) ->
        $scope.tagging_drafts = []
        i = 0
        while i < data.drafts.length
          if data.drafts[i].item_type == "Tagging"
            $scope.tagging_drafts.push data.drafts[i]
          i++
      )
    )
]