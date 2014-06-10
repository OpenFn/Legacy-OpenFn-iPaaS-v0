'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope', '$filter', 'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, $filter, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    $scope.mapping = {
      mappingSalesforceObjects: []
    }

    $scope.sfFilter = {}
    $scope.odkFilter = {}

    # This is called on the edit view
    $scope.init = (mappingId) ->
      $scope.editMode = true
      Mapping.get(id: mappingId).$promise.then((response) ->
        $scope.mapping = MappingService.reverseMapping(response.mapping)
        console.log $scope.mapping
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
        $scope.salesforceObjects = response.data.salesforce_objects

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

    $scope.$watch "mapping.salesforceObjectName", (salesforceObjectId) ->
      if salesforceObjectId isnt undefined

        sfObject = (i for i in $scope.salesforceObjects when i.name is salesforceObjectId)[0]
        index = $scope.salesforceObjects.indexOf(sfObject)
        $scope.salesforceObjects.splice(index, 1)

        SalesforceObjectField.query(salesforce_object_id: salesforceObjectId).$promise.then (response) ->
          sfObject.fields = response
          $scope.mapping.mappingSalesforceObjects.push sfObject

    $scope.$watch "odkFilter.field_name", (fieldName) ->
      $scope.getOdkFields(fieldName)

    ######## Default behaviour

    $scope.prepare()
]