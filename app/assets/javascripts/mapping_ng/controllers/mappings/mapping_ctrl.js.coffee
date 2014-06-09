'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope', '$filter', 'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, $filter, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    $scope.mapping = {
      salesforce_fields: []
    }

    $scope.sfFilter = {}
    $scope.odkFilter = {}

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
          $scope.getOdkFields($scope.odkFilter.field_name)

      $scope.sfSortableOptions =
        connectWith: '.sf-connected-sortable'

      OdkForm.query.then (response) ->
        $scope.odkForms = response.data.odk_forms

      SalesforceObject.query.then (response) ->
        $scope.salesForceObjects = response.data.salesforce_objects
        console.log $scope.salesForceObjects

    $scope.saveMapping = ->
      MappingService.saveMapping($scope.mapping).$promise.
        then(
          (response) ->
            window.location = "/mappings/#{response.mapping.id}"
          (error_response) ->
            $scope.errors = error_response.data.errors
        )

    $scope.getOdkFields = (fieldName) ->
      if fieldName is ''
        $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)
      else
        $scope.odkFormFields = $filter('filter')($scope.originalOdkFormFields, $scope.odkFilter)

    ######## Watches

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          $scope.originalOdkFormFields = response
          $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)

    $scope.$watch "mapping.saleforce_object_name", (salesForceObjectId) ->
      if salesForceObjectId isnt undefined
        $scope.salesforceObjectFields = []

        SalesforceObjectField.query(salesforce_object_id: salesForceObjectId).$promise.then (response) ->
          $scope.originalSalesforceObjectFields = response
          $scope.salesforceObjectFields = angular.copy($scope.originalSalesforceObjectFields)

    $scope.$watch "sfFilter.field_name", (fieldName) ->
      if fieldName is ''
        $scope.salesforceObjectFields = angular.copy($scope.originalSalesforceObjectFields)
      else
        $scope.salesforceObjectFields = $filter('filter')($scope.originalSalesforceObjectFields, $scope.sfFilter)

    $scope.$watch "odkFilter.field_name", (fieldName) ->
      $scope.getOdkFields(fieldName)

    ######## Default behaviour

    $scope.prepare()
]