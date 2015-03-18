'use strict'

OpenFn.Mappings.controller 'NewMappingCtrl',
  ($scope, $http, $location) ->

    $http.post('/api/v1/mappings')
      .success (data) ->
        console.log data
        console.log "Redirecting to edit page"
        $location.url("/mappings/#{data.id}/edit")
      .error (data, status, headers, config) ->
        console.error data, status, headers, config



