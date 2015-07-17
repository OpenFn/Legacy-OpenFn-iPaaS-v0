@controllerModule.controller 'RatingDemoCtrl', ($scope) ->
  $scope.rate = 0
  $scope.max = 5
  $scope.isReadonly = false

  $scope.hoveringOver = (value) ->
    $scope.overStar = value
    $scope.percent = 100 * value / $scope.max
    return

  return