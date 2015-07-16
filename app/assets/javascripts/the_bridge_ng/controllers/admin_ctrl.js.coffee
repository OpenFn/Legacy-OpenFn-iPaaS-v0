@controllerModule.controller 'AdminController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product_drafts = []
  $scope.tagging_drafts = []

  $http.get("/admin/drafts").success((data) ->
    i = 0
    while i < data.drafts.length
      if data.drafts[i].item_type == "Product"
        $scope.product_drafts.push data.drafts[i]
        i++
        continue
      if data.drafts[i].item_type == "Tagging"
        $scope.tagging_drafts.push data.drafts[i]
        i++

    console.log("drafts",$scope.drafts)
  )

  $scope.getProduct = (draft) ->
    $http.get("/product/get_name/#{draft.item_id}.json").success((data) ->
      draft.product_name = data
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
    draft.response = "publish"
    $http.post("/tags/publish/#{draft.id}", draft).success((data) ->
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
    draft.response = "discard"
    $http.post("/tags/publish/#{draft.id}", draft).success((data) ->
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