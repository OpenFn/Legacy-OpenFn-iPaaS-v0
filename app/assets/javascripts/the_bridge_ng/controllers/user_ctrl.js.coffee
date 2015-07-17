@controllerModule.controller 'UserController', ['$scope', '$location', '$http', '$routeParams', '$timeout', ($scope, $location, $http, $routeParams, $timeout) ->
  $scope.tag = {}
  $scope.searchText = ""
  $scope.searchTagText = ""
  $scope.formData = {}


  $scope.submitUserForm = () ->

    $http.post('/users', $scope.formData).success((data) ->
      console.log 'successss'
    )

  $scope.checkForCurrentUser = () ->
    $http.get('/users/get/current_user').success((data) ->
      console.log 'data'
    )

    # console.log("in user controller angular")

  # $scope.submitODK = () ->
  #   $http.post('/users/{{current_user.id}}', $scope.formData).success((data) ->
  #     console.log 'successss'


  # $scope.SetPlan = (plan) ->
  #   $('.plan_btn label').removeClass 'active'
  #   $('.plan_btn input').each ->
  #     if $(this).data('name') == plan
  #       $(this).attr 'checked', true
  #       $(this).parent('label').addClass 'active'
  #     return
  #   return

  # $('.pay').click ->
  #   input = $(this).find('input')
  #   if plan != 'Startup'
  #     if input.data('name') == 'Startup' and !input.is(':checked')
  #       $('.coupon_field').show()
  #     else
  #       $('.coupon_field').hide()
  #   return

  # handler = StripeCheckout.configure(
  #   key: '<%= Rails.configuration.stripe[:publishable_key] %>'
  #   token: (token) ->
  #     $('#user_stripe_token').val token.id
  #     plan_name = $('.plan_btn').find('input:checked').data('name')
  #     $('#user_subscription_plan').val plan_name
  #     $('form#signup_form').submit()
  #     return
  # )

  # $('.submit_btn').click (e) ->
  #   amount = $('.plan_btn').find('input:checked').data('amount')
  #   plan_name = $('.plan_btn').find('input:checked').data('name')
  #   email = $('#user_email').val()
  #   if amount == 'free'
  #     $('#user_subscription_plan').val 'Free'
  #   else if $('#user_subscription_plan').val() != plan_name
  #     if amount != 'free'
  #       if $('#user_stripe_token').val() == ''
  #         handler.open
  #           name: 'OpenFn'
  #           amount: amount
  #           email: email
  #           panelLabel: 'Signup for ' + plan_name
  #         return false
  #   return
  # # Close Checkout on page navigation
  # $(window).on 'popstate', ->
  #   handler.close()
  #   return


    
]



