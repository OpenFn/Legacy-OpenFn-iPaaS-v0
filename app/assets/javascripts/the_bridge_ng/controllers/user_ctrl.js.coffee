@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""

  $scope.formData = {}

  console.log("in user controller angular")
 
  $scope.test1 = () ->
    console.log("does this test work?")
    console.log("in user controller angular")


  $scope.submitUserForm = () ->
    $scope.formData =
      'email': $scope.email
      'password': $scope.password
      'password_confirmation': $scope.password_confirmation
      'first_name': $scope.first_name
      'last_name': $scope.last_name
      'organisation': $scope.organisation

    $http.post('/signup', $scope.formData).success((data) ->
      console.log 'successss'
    )

    console.log("in user controller angular")

    
]
