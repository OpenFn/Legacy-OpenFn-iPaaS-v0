@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.formData = {}
  $scope.formData.email = ""
  $scope.salesforceData = {}
  $scope.current_plan = ""
  $scope.new_plan = ""
  $scope.coupon = false
  $scope.buttons = []
  button_names = ["Free","Entry","Startup","Growth","Enterprise"]
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
    $scope.current_plan= data
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

    $http.post('/users', $scope.formData).success((data) ->
      console.log 'successss'
    )

  $scope.submitODK = () ->
    $http.post('/users/{{current_user.id}}', $scope.formData).success((data) ->
      console.log 'successss'
    )


  #   <%if current_user%>
  #   plan = '<%=current_user.plan.try(:name) rescue ""%>';
  #   if (plan != "")
  #     SetPlan(plan);
  # <%else%>
  #   plan = 'Free'
  #   $('.plan_btn input').first().attr('checked', true)
  #   $('.plan_btn label').first().addClass('active');
  # <%end%>
  # <%if params[:plan].present?%>
  #   plan = '<%=params[:plan]%>';
  #   if (plan != "")
  #     SetPlan(plan);
  # <%end%>
  # function SetPlan(plan){
  #   $('.plan_btn label').removeClass('active');
  #   $('.plan_btn input').each(function(){
  #     if ($(this).data('name') == plan){
  #       $(this).attr('checked', true);
  #       $(this).parent('label').addClass('active');
  #     }
  #   })
  # }
  # $(".pay").click(function(){
  #   input = $(this).find('input');
  #   if (plan != 'Startup'){
  #     if(input.data('name') == 'Startup' && !input.is(":checked") )
  #       $(".coupon_field").show();
  #     else
  #       $(".coupon_field").hide();
  #   }
  # });
  



    
]
