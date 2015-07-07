@controllerModule.controller 'ModalController', ['$scope', '$modalInstance', '$location', '$http', ($scope, $modalInstance, $location, $http) ->
  $scope.ok =  () ->
    $modalInstance.close()

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')

]