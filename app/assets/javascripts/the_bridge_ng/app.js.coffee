'use strict'

Array::filter = (func) -> x for x in @ when func(x)

@the_bridge = angular.module('the_bridge', [
  'ngRoute',
  'ngResource',
  'ui.tree',
  'ngAnimate',
  'ngSanitize',
  'the_bridge.controllers',
  'the_bridge.directives',
  'the_bridge.resources',
  'the_bridge.services',
  'the_bridge.filters',
  'the_bridge.config',
  'OpenFn',
  'OpenFn.Mappings',
  'OpenFn.Services',
  'ui.sortable',
  'ui.bootstrap',
  'ng-rails-csrf',
  'mgcrea.bootstrap.affix',
  'angulartics',
  'angulartics.google.analytics',
  'angular-growl'
 ])

# Handles to controllers for namespace collisions with the new OpenFn app.
# As of today AngularJS doesn't handle namespace collisions for services so
# if you've got 2 different modules with the service named the same way and
# you include both modules in your app, only one service will be available.
@Legacy = {
  controllers: {},
  modules: {

  }
}

@controllerModule = angular.module 'the_bridge.controllers', []
@directiveModule  = angular.module 'the_bridge.directives', []
@resourceModule   = angular.module 'the_bridge.resources', []
@serviceModule    = angular.module 'the_bridge.services', []
@filterModule     = angular.module 'the_bridge.filters', []
@configModule     = angular.module 'the_bridge.config', []


@the_bridge.factory 'UserSession', ['$http', '$modal', ($http, $modal) ->
  clear: ->
    sessionStorage.removeItem('currentUser')

  store: (user) ->
    sessionStorage.setItem('currentUser', JSON.stringify(user))

  getUser: ->
    JSON.parse(sessionStorage.getItem('currentUser'))

  checkSession: ->
    $http.get("/user/current")

  isLoggedIn: ->
    sessionStorage.getItem('currentUser') != null

  showLoginModal: ->
    modalInstance = $modal.open
      templateUrl: '/templates/modalTemplate.html',
      controller: 'LoginController'
  ]
      
@the_bridge.factory 'httpInterceptor', ['$location', '$injector', ($location, $injector) ->
  request: (config) ->
    UserSession = $injector.get('UserSession')
    if (!config.url.includes('/user/current') || !config.url.includes('templates')) && !UserSession.isLoggedIn
      
      UserSession.checkSession().then (result) ->
        if result.success
          UserSession.store(result.user)
        else
          UserSession.clear
          UserSession.showLoginModal
      return config     
    else
      return config
]


  

@the_bridge.config ['$routeProvider', '$locationProvider', 'growlProvider', '$httpProvider', ($routeProvider, $locationProvider, growlProvider, $httpProvider) ->
  growlProvider.globalTimeToLive(3000);
  growlProvider.globalPosition('top-right');

  $locationProvider.html5Mode true

  $httpProvider.interceptors.push('httpInterceptor')

  # on every request check if the user is logged in. 
    # GET users/current_users
      # if status == 401 -> redirect users_sessions/new
        # in session storage, set the redirect-to-URL after the user logs in
        # if the user logs in, redirect him to the stored URL 
      # if status == 200, do nothing

  unless Features.new_mapping_page
    $routeProvider
      .when '/mappings/new',
        controller: Legacy.controllers.NewMappingCtrl
        templateUrl: '../the_bridge_templates/mappings/new.html'

      .when '/mappings/:id',
        controller: 'EditMappingCtrl'
        templateUrl: '../the_bridge_templates/mappings/edit.html'
        resolve:
          mappingResponse: ($q, $route, Mapping) ->
            defer = $q.defer()

            # Load the mapping
            Mapping.get(id: $route.current.params.id).$promise.then((response) ->
              defer.resolve response
            )

            defer.promise

  $routeProvider
    .when('/marketplace', {
      templateUrl: '../the_bridge_templates/marketplace/index.html',
    })
    .when('/marketplace/search/:search', {
      templateUrl: '../the_bridge_templates/marketplace/index.html',
    })
    .when('/marketplace/search/', {
      templateUrl: '../the_bridge_templates/marketplace/index.html',
    })
    .when('/product/:id', {
      templateUrl: '../the_bridge_templates/product/show.html',
    })
    .when('/product/:id/edit', {
      templateUrl: '../the_bridge_templates/product/edit.html',
    })
    .when('/admin/get_drafts', {
      templateUrl: '../the_bridge_templates/product/admin.html',
    })
    .when('/release-notes', {
      templateUrl: '../the_bridge_templates/release_notes/index.html'
    })
    .when('/pricing', {
      templateUrl: '../the_bridge_templates/static/pricing.html'
    })
    .when('/developers', {
      templateUrl: '../the_bridge_templates/static/developers.html'
    })
    .when('/our_team', {
      templateUrl: '../the_bridge_templates/team/our_team.html'
    })
    .when('/welcome', {
      templateUrl: '../the_bridge_templates/static/welcome2.html'
    })
    .when('/tags', {
      templateUrl: '../the_bridge_templates/tags/index.html'
    })
    .when('/', {
      templateUrl: '../the_bridge_templates/static/welcome.html',
      controller: ($scope, $http) ->
        $scope.productCount = null
        $scope.userCount = null
        $scope.submissionCount = null
        $scope.productConnectedCount = null

        $http.get '/welcome_stats'
        .success (data) ->
          $scope.submissionCount = data.submissionCount
          $scope.orgCount = data.orgCount
          $scope.productPublicCount = data.productPublicCount
          $scope.productConnectedCount = data.productConnectedCount

    })
    .otherwise({redirectTo:"/"})
]


@the_bridge.controller 'HeaderController', ['$scope', 'UserSession', '$http', ($scope, UserSession, $http) ->
  $scope.openModal = UserSession.showLoginModal
  $scope.isLoggedIn = UserSession.isLoggedIn
  $scope.currentUser = UserSession.getUser

  $scope.logout = (data) ->
    console.log 'in logout'
    $http.post('/logout').success((resp) ->
      console.log(resp)
      sessionStorage.removeItem('currentUser')
      window.location = "/"
      return
    ).error (resp) ->
      return
]


@the_bridge.directive 'header', ->
  {
    restrict: 'A'
    replace: true
    scope: user: '='
    templateUrl: 'the_bridge_templates/shared/header.html'
    controller: 'HeaderController'
  }

