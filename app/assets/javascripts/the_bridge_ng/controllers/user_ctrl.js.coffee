@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""

  $scope.formData = {}
  $scope.odkData = {}
  $scope.sfData = {}
  $scope.formData.plan = "Free"
  $scope.formData.subscription_plan = "Free"

  $scope.odkUserId = ""
  $scope.sfUserId = ""
  $scope.currentUserId = ""
  $scope.salesforceData = {}
  $scope.current_plan = ""
  $scope.new_plan = ""
  
  
  $scope.coupon = false
  $scope.buttons = []
  button_names = ["Free","Entry","Startup","Growth","Enterprise"]

  $http.get('/user/user_data').success((data) ->
    $scope.formData.email = data.email
    $scope.formData.first_name= data.first_name
    $scope.formData.last_name= data.last_name
    $scope.formData.organisation= data.organization
  )

  i = 0
  while i < button_names.length
    button = {}
    button.name = button_names[i]
    button.active = false
    button.checked = false
    $scope.buttons.push button
    i++

  $http.get('/publishable_key').success((data) ->
    $scope.key = data
  )


  $http.get('/check_plan').success((data) ->
    $scope.formData.plan = data
    $scope.odkData.plan = data
    $scope.sfData.plan = data

    $scope.current_plan = data
    i = 0
    found = false
    while i < $scope.buttons.length
      if $scope.buttons[i].name == $scope.current_plan
        found = true
        $scope.buttons[i].active = true
        $scope.buttons[i].checked = true
        break
      i++
    if !found
      $scope.buttons[0].active = true
      $scope.buttons[0].checked = true
    
  )

  $http.get('/check_current_user_id').success((data) ->
    $scope.odkUserId = data
    $scope.sfUserId = data
    $scope.currentUserId = data
   
  )

  $scope.clickPlan = (plan) ->
    i = 0
    while i < $scope.buttons.length
      if $scope.buttons[i].name == plan
        $scope.buttons[i].active = true
        $scope.buttons[i].checked = true
        $scope.new_plan = plan 
      else
        $scope.buttons[i].active = false
        $scope.buttons[i].checked = false
      i++
    if ($scope.current_plan != "Startup") && ($scope.new_plan == "Startup")
      $scope.coupon = true
    else
      $scope.coupon = false

  $scope.submitUserForm = () ->
    if $scope.currentUserId == ""
      $http.post('/users', $scope.formData).success((data) ->
        window.location = "/"
      )

    else
      $http.put('/users/' + $scope.currentUserId, $scope.formData).success((data) ->
        window.location = "/"
      )
    

  $scope.submitODKForm = () ->
    $http.put('/users/' + $scope.odkUserId, $scope.odkData).success((data) ->
      window.location = "/"
    )

  $scope.submitSFForm = () ->
    $http.put('/users/' + $scope.sfUserId, $scope.sfData).success((data) ->
      window.location = "/"

    )
    
]
