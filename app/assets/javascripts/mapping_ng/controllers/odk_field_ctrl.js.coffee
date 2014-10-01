'use strict'

@controllerModule.controller 'OdkFieldCtrl', ['$scope', '$rootScope', 'OdkFieldSalesforceField', 'SalesforceObjectField',
  ($scope, $rootScope, OdkFieldSalesforceField, SalesforceObjectField) ->

    ########## VARIABLE ASSIGNMENT

    ########## FUNCTIONS

    $scope.deleteField = (sfField) ->
      i = $scope.odkFormField.salesforceFields.indexOf(sfField)
      $scope.odkFormField.salesforceFields.splice(i, 1)

    $scope.updateLookupField = (odkField, sfField) ->
      OdkFieldSalesforceField.update(
        mapping_id: $scope.mapping.id
        odk_field_id: odkField.id
        id: sfField.id
        odk_field_salesforce_field:
          lookup_field_name: sfField.lookupFieldName
      )

    ########## WATCHES

    $scope.$watchCollection "odkFormField.salesforceFields", (newValue, oldValue) ->
      if newValue.length > oldValue.length
        # Adding a new field
        newField = newValue.diff(oldValue)[0]

        OdkFieldSalesforceField.save(
          mapping_id: $scope.mapping.id
          odk_field_id: $scope.odkFormField.id
          odk_field_salesforce_field:
            salesforce_field_id: newField.id
        )

      else if newValue.length < oldValue.length
        # Deleting an existing field

        deletedField = oldValue.diff(newValue)[0]
        OdkFieldSalesforceField.delete(
          mapping_id: $scope.mapping.id
          odk_field_id: $scope.odkFormField.id
          id: deletedField.id
        )
      else if newValue.length = oldValue.length
        # Initial Load
        newField = newValue[0]

        if newField.data_type is 'reference'
          SalesforceObjectField.query(
            mapping_id: $scope.mapping.id
            salesforce_object_id: newField.field_name
          ).$promise.then (response) ->
            newField.lookupFields = response


    ########## BEFORE FILTERS

]
