@serviceModule.factory 'UserSession', ['$http', '$modal', ($http, $modal) ->
    clear: ->
      sessionStorage.removeItem('currentUser')

    store: (user) ->
      sessionStorage.setItem('currentUser', user)

    checkSession: ->
      $http.get("/user/check_login?redirect=#{url}")

    isLoggedIn: ->
      sessionStorage.getItem('currentUser') != undefined

    showLoginModal: ->
      modalInstance = $modal.open
        templateUrl: '/templates/modalTemplate.html',
        controller: 'ModalController'

    ]
      