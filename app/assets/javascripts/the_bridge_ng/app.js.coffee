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

@the_bridge.config ['$routeProvider', '$locationProvider', 'growlProvider', ($routeProvider, $locationProvider, growlProvider) ->
  growlProvider.globalTimeToLive(3000);
  growlProvider.globalPosition('top-right');

  $locationProvider.html5Mode true

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
    .when('/metrics/organisation', {
      templateUrl: '../the_bridge_templates/metrics/organisations/index.html',
      controller: 'OrganisationsIndexCtrl'
    })
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
    .when('/release-notes', {
      templateUrl: '../the_bridge_templates/release_notes/index.html'
    })
    .when('/pricing', {
      templateUrl: '../the_bridge_templates/static/pricing.html'
    })
    .when('/developers', {
      templateUrl: '../the_bridge_templates/static/developers.html'
    })
    .when('/welcome', {
      templateUrl: '../the_bridge_templates/static/welcome2.html'
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

particlesJS("particles-js", {
  "particles": {
    "number": {
      "value": 80,
      "density": {
        "enable": true,
        "value_area": 800
      }
    },
    "color": {
      "value": "#ffffff"
    },
    "shape": {
      "type": "circle",
      "stroke": {
        "width": 0,
        "color": "#000000"
      },
      "polygon": {
        "nb_sides": 5
      },
      "image": {
        "src": "img/github.svg",
        "width": 100,
        "height": 100
      }
    },
    "opacity": {
      "value": 0.5,
      "random": false,
      "anim": {
        "enable": false,
        "speed": 1,
        "opacity_min": 0.1,
        "sync": false
      }
    },
    "size": {
      "value": 3,
      "random": true,
      "anim": {
        "enable": false,
        "speed": 40,
        "size_min": 0.1,
        "sync": false
      }
    },
    "line_linked": {
      "enable": true,
      "distance": 150,
      "color": "#ffffff",
      "opacity": 0.4,
      "width": 1
    },
    "move": {
      "enable": true,
      "speed": 6,
      "direction": "none",
      "random": false,
      "straight": false,
      "out_mode": "out",
      "bounce": false,
      "attract": {
        "enable": false,
        "rotateX": 600,
        "rotateY": 1200
      }
    }
  },
  "interactivity": {
    "detect_on": "canvas",
    "events": {
      "onhover": {
        "enable": true,
        "mode": "grab"
      },
      "onclick": {
        "enable": true,
        "mode": "push"
      },
      "resize": true
    },
    "modes": {
      "grab": {
        "distance": 140,
        "line_linked": {
          "opacity": 1
        }
      },
      "bubble": {
        "distance": 400,
        "size": 40,
        "duration": 2,
        "opacity": 8,
        "speed": 3
      },
      "repulse": {
        "distance": 200,
        "duration": 0.4
      },
      "push": {
        "particles_nb": 4
      },
      "remove": {
        "particles_nb": 2
      }
    }
  },
  "retina_detect": true
});