@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.formData = {}
  $scope.formData.email = ""
  $scope.formData.plan = "Free"
  $scope.odkUserId = ""
  $scope.sfUserId = ""

  $scope.odkData = {}
  $scope.sfData = {}

  $http.get('/check_plan').success((data) ->
    $scope.formData.plan = data
    $scope.odkData.plan = data
    $scope.sfData.plan = data

    
  )

  $http.get('/check_current_user_id').success((data) ->
    $scope.odkUserId = data
    $scope.sfUserId = data
   
  )


  $scope.submitUserForm = () ->
    $http.post('/users', $scope.formData).success((data) ->

    )

  $scope.submitODKForm = () ->
    $http.put('/users/' + $scope.odkUserId, $scope.odkData).success((data) ->

    )

  $scope.submitSFForm = () ->
    $http.put('/users/' + $scope.sfUserId, $scope.sfData).success((data) ->

    )


# edit_user_path(odkUserId)
    
]
