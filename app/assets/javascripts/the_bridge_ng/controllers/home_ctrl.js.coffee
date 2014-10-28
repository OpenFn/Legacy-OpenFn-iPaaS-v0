@the_bridge.controller 'HomeController', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.products = []
  $scope.source = {}
  $scope.destination = {}

  $http.get('./products.json').success((data) ->
    $scope.products = data.products
  )
  
  $scope.setSource = (product) ->
    $scope.source = product
    newMapping() if selectionCompleted()
  
  $scope.setDestination = (product) ->
    $scope.destination = product
    newMapping() if selectionCompleted()

  $scope.isSource = (product) ->
    $scope.source == product
  
  $scope.isDestination = (product) ->
    $scope.destination == product

  selectionCompleted = () ->
    !jQuery.isEmptyObject($scope.source) && !jQuery.isEmptyObject($scope.destination)

  newMapping = () ->
    window.location = '/mappings/new'
]
