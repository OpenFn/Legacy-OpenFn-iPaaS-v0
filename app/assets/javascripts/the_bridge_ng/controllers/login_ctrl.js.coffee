@controllerModule.controller 'LoginController', ['$scope', 'UserSession', '$location', '$modal', '$http', '$routeParams', '$timeout', ($scope, UserSession, $location, $modal, $http, $routeParams, $timeout) ->

  $scope.openModal = UserSession.showLoginModal

  $scope.login = (data) ->
    console.log 'in login'
    $http.post('/login',
      email: data.email
      password: data.password).success((resp) ->
      console.log(resp.user)
      sessionStorage.setItem('currentUser', JSON.stringify(resp.user))
      window.location = resp.location
      return
    ).error (resp) ->
      $scope.alert = "The username or password are incorrect"
      return


]