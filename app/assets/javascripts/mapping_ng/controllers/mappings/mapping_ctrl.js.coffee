'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope', 'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    $scope.mapping = {
      salesforce_fields: []
    }

    # This is called on the edit view
    $scope.init = (mappingId) ->
      $scope.editMode = true
      Mapping.get(id: mappingId).$promise.then((response) ->
        $scope.mapping = response.mapping
      )

    $scope.prepare = ->
      $scope.odkSortableOptions =
        connectWith: '.odk-connected-sortable'
        stop: (event, ui) ->
          $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)

      $scope.sfSortableOptions =
        connectWith: '.sf-connected-sortable'

      OdkForm.query.then (response) ->
        $scope.odkForms = response.data.odk_forms

      SalesforceObject.query.then (response) ->
        $scope.salesForceObjects = response.data.salesforce_objects

    $scope.saveMapping = ->
      MappingService.saveMapping($scope.mapping).$promise.
        then(
          (response) ->
            window.location = "/mappings/#{response.mapping.id}"
          (error_response) ->
            $scope.errors = error_response.data.errors
        )


    ######## Watches

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          $scope.odkFormFields = response
          $scope.originalOdkFormFields = angular.copy($scope.odkFormFields)

    $scope.$watch "mapping.saleforce_object_name", (salesForceObjectId) ->
      if salesForceObjectId isnt undefined
        $scope.salesforceObjectFields = []

        SalesforceObjectField.query(salesforce_object_id: salesForceObjectId).$promise.then (response) ->
          $scope.salesforceObjectFields = response

    ######## Default behaviour

    $scope.prepare()
]