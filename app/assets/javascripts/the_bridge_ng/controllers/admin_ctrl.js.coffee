@controllerModule.controller 'AdminController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.product_drafts = []
  $scope.tagging_drafts = []
  $scope.product_comparisons = []

  $http.get("/admin/drafts").success((data) ->
    i = 0
    while i < data.drafts.length
      if data.drafts[i].item_type == "Product"
        draft = {}
        draft.current = {}
        draft.update = {}
        draft.update = data.drafts[i]
        $scope.product_drafts.push draft
        i++
        continue
      if data.drafts[i].item_type == "Tagging"
        $scope.tagging_drafts.push data.drafts[i]
        i++

  )

  $scope.getProductComparison = (draft) ->
    
    $http.get("/product/get/#{draft.update.item_id}.json").success((data) ->
      if draft.update.event == "create"
        draft.current.name = "New Product"
      else
        draft.current = data
      )

  $scope.getProductName = (draft) ->
    $http.get("/product/get/#{draft.item_id}.json").success((data) ->
      draft.product_name = data.name
      )

  $scope.publish = (draft) ->
    $http.put("/admin/drafts/#{draft.update.id}").success((data) ->
        ind = $scope.product_drafts.indexOf(draft)
        $scope.product_drafts.splice(ind,1)
    )

  $scope.discard = (draft) ->
    $http.delete("/admin/drafts/#{draft.update.id}").success((data) ->
        ind = $scope.product_drafts.indexOf(draft)
        $scope.product_drafts.splice(ind,1)
    )
  $scope.tagging_publish = (draft) ->
    draft.response = "publish"
    $http.post("/tags/publish/#{draft.id}", draft).success((data) ->
      ind = $scope.tagging_drafts.indexOf(draft)
      $scope.tagging_drafts.splice(ind,1)
    )

  $scope.tagging_discard = (draft) ->
    draft.response = "discard"
    $http.post("/tags/publish/#{draft.id}", draft).success((data) ->
      ind = $scope.tagging_drafts.indexOf(draft)
      $scope.tagging_drafts.splice(ind,1)
    )
]