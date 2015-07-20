@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.formData = {}
  $scope.formData.email = ""
  $scope.test1 = () ->
    console.log("does this test work?")
    console.log("in user controller angular")


  $scope.submitUserForm = () ->
    console.log("in da method")
    console.log($scope.formData)

    $http.post('/users', $scope.formData).success((data) ->
      console.log 'successss'
    )

    console.log("in user controller angular")



    
]