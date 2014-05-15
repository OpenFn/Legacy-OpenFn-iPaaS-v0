'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    $scope.mapping = {}

    $scope.sortableOptions =
      connectWith: '.connected-sortable'
      stop: (event, ui) ->
        $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)
        MappingService.updateMapping($scope.mapping.saleforce_object_name, $scope.salesforceObjectFields)

    OdkForm.query.then (response) ->
      $scope.odkForms = response.data

    SalesforceObject.query.then (response) ->
      $scope.salesForceObjects = response.data

    $scope.saveMapping = ->
      MappingService.saveMapping($scope.mapping.name, $scope.mapping.odk_formid).$promise.
      then(
        (mapping) ->
          window.location = "/mappings/#{mapping.id}"
        (error_response) ->
          $scope.errors = error_response.data.errors
      )

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          $scope.odkFormFields = response
          $scope.originalOdkFormFields = angular.copy($scope.odkFormFields)

    $scope.$watch "mapping.saleforce_object_name", (salesForceObjectId) ->
      if salesForceObjectId isnt undefined
        $scope.salesforceObjectFields = []

        if salesforceObjectFields = MappingService.getMappingForSalesForce(salesForceObjectId)
          $scope.salesforceObjectFields = salesforceObjectFields
        else
          SalesforceObjectField.query(salesforce_object_id: salesForceObjectId).$promise.then (response) ->
            $scope.salesforceObjectFields = response
]