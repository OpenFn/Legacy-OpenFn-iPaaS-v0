@controllerModule.controller 'LoginController', ['$scope', '$location', '$modal', '$http', '$routeParams', '$timeout', ($scope, $location, $modal, $http, $routeParams, $timeout) ->
  $scope.showModal = () ->
    modalInstance = $modal.open
      templateUrl: 'modalTemplate.html',
      controller: 'ModalController'

  $scope.checkLogin = (path) ->
    url = if path? then path else $location.url() 

    $http.get("/user/check_login?redirect=#{url}").success((data) ->
      if data.status == 'login'
        $scope.showModal()
      else
        window.location = url
    )
]