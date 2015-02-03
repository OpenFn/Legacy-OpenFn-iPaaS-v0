'use strict'

OpenFn.Mappings.controller 'MappingViewCtrl',
  (mappingId,MappingViewModel,$q,$scope,$modal) ->

    self = this

    self.ui = {
      initializing: true
    }

    $q (resolve,reject) ->
      # Hand over mappingId to View model and bind callbacks.
      self.mapping = new MappingViewModel(mappingId,{

        # Just in case for now, props seem to update quickly.
        onUpdate: ->
          $scope.$apply()
        onChange: ->
          console.log "got change from viewmodel:", arguments
        # Open modal when we get an error
        onError: (mapping,e) ->
          $modal.open
            templateUrl: "/templates/errorModal.html"
            controller: "ErrorModalCtrl"
            size: "md"
            resolve:
              message: -> e

      })
      resolve(true)
    .then ->
      self.ui.initializing = false
    .catch (reason) ->
      console.error reason

    return this

.controller 'ErrorModalCtrl', ($modalInstance,$scope,message) ->

  $scope.message = message

  $scope.ok = ->
    $modalInstance.close()
