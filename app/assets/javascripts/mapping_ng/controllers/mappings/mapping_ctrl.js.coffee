'use strict'

@controllerModule.controller 'MappingCtrl', ['$scope', 'Mapping', 'OdkForm', 'OdkFormField', 'SalesforceObject', 'SalesforceObjectField', 'MappingService'
  ($scope, Mapping, OdkForm, OdkFormField, SalesforceObject, SalesforceObjectField, MappingService) ->

    $scope.mapping = {
      salesforce_fields: []
    }

    $scope.init = (mappingId) ->
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
        $scope.odkForms = response.data

      SalesforceObject.query.then (response) ->
        $scope.salesForceObjects = response.data

    $scope.saveMapping = ->
      MappingService.saveMapping($scope.mapping).$promise.
        then(
          (mapping) ->
            window.location = "/mappings/#{mapping.id}"
          (error_response) ->
            $scope.errors = error_response.data.errors
        )


    ######## Watches

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          console.log response
          #$scope.odkFormFields = response
          #$scope.originalOdkFormFields = angular.copy($scope.odkFormFields)

    $scope.$watch "mapping.saleforce_object_name", (salesForceObjectId) ->
      if salesForceObjectId isnt undefined
        $scope.salesforceObjectFields = []

        # if salesforceObjectFields = MappingService.getMappingForSalesForce(salesForceObjectId)
        #   $scope.salesforceObjectFields = salesforceObjectFields
        # else
        SalesforceObjectField.query(salesforce_object_id: salesForceObjectId).$promise.then (response) ->
          $scope.salesforceObjectFields = response

    ######## Default behaviour

    $scope.prepare()
]