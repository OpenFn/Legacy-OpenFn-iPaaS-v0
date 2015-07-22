@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.formData = {}
  $scope.formData.email = ""
  $scope.formData.plan = "Free"
  $scope.odkUserId = ""

  $scope.odkData = {}

  $http.get('/check_plan').success((data) ->
    $scope.formData.plan = data
    $scope.odkData.plan = data

    
  )

  $http.get('/check_current_user_id').success((data) ->
    $scope.odkUserId = data
   
  )


  $scope.submitUserForm = () ->
    $http.post('/users', $scope.formData).success((data) ->
      console.log 'successss'
    )

  $scope.submitODKForm = () ->
    $http.put('/users/' + $scope.odkUserId + '/edit', $scope.odkData).success((data) ->
      console.log 'odk info updated yay'
    )


# edit_user_path(odkUserId)
    
]
