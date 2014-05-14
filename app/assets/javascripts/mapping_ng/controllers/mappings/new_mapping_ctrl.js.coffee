'use strict'

@controllerModule.controller 'NewMappingCtrl', ['$http', '$scope', 'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField'
  ($http, $scope, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField) ->

    $scope.mapping = {}

    $scope.sortableOptions =
      connectWith: '.connected-sortable'
      stop: (event, ui) ->
        $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)

    OdkForm.query.then (response) ->
      $scope.odkForms = response.data

    SalesforceObject.query.then (response) ->
      $scope.salesForceObjects = response.data

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          $scope.odkFormFields = response
          $scope.originalOdkFormFields = angular.copy($scope.odkFormFields)

    $scope.$watch "mapping.saleforce_object_name", (salesForceObjectId) ->
      if salesForceObjectId isnt undefined
        SalesforceObjectField.query(salesforce_object_id: salesForceObjectId).$promise.then (response) ->
          $scope.salesforceObjectFields = response

]