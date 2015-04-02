'use strict'

OpenFn.Mappings.factory 'MappingViewModel', [
  '$resource','$http','$q', 'ConnectionProfiles', ($resource,$http,$q,ConnectionProfiles) ->

    class Mapping

      constructor: (id, callbacks) ->
        @callbacks = callbacks

        @attrs = {
          id: id || null
          name: ""
          enabled: false
        }

        @state = {
          new: !id
          loading: false
          canSave: false
        }

        @initializeProps [
          'id'
          'name'
          'active'
          'enabled'
        ]

      initializeProps: (properties) ->

        for property in properties
          do (property) =>
            Object.defineProperty @, property, {
              get: -> @attrs[property]
              set: (newValue) ->
                @attrs[property] = newValue
                @state['canSave'] = true
                @emit('onChange')
                @attrs[property]
              enumerable: true
              configurable: false
            }

      emit: (evt,payload) ->
        console.log "Called #{evt}"
        @callbacks[evt](this,payload)

      update: ->
        $http.put("/api/v1/mappings/#{@id}.json", @attrs)
          .success (data) =>
            @emit('onUpdate')
            angular.extend(@attrs, data.mapping)
            @state.canSave = false
            resolve(true)
          .error (data, status, headers, config) ->
            if status == 401
              reject("You need to be logged in to create a mapping.")
            else
              reject(status)

      updateFromServer: (resp) ->
        angular.extend(@.attrs, resp)
        console.log resp

      fetchFromServer: () ->
        @state.loading = true
        $http.get("/mappings/#{@id}.json").success (data) =>
          @updateFromServer(data.mapping)
          @state.loading = false
        .error () ->
          console.error arguments
          @state.loading = false


      resourceAttrs: () ->
        {
          id: @attrs.id,
          mapping: {
            name: @attrs.name
            enabled: @attrs.enabled
            active: @attrs.active
          }
        }

      create: ->
        $q (resolve,reject) =>
          @state.saving = true
          $http.post("/mappings", @attrs).success (data) =>
            angular.extend(@attrs, data.mapping)
            @state.new = false
            resolve(true)
          .error (data, status, headers, config) ->
            if status == 401
              reject("You need to be logged in to create a mapping.")
            else
              reject(status)

        .then =>
          @state.saving = false
        .then =>
          @emit 'onServerUpdate'
        .catch (reason) =>
          @state.saving = false
          @emit 'onError', reason
          console.log reason

]
