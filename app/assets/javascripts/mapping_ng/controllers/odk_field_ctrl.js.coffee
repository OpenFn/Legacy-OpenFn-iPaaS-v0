'use strict'

@controllerModule.controller 'OdkFieldCtrl', ['$scope', '$rootScope', 'OdkFieldSalesforceField',
  ($scope, $rootScope, OdkFieldSalesforceField) ->

    ########## VARIABLE ASSIGNMENT

    ########## FUNCTIONS

    $scope.deleteField = (sfField) ->
      i = $scope.odkFormField.salesforceFields.indexOf(sfField)
      $scope.odkFormField.salesforceFields.splice(i, 1)

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

      else if newValue < oldValue
        # Deleting an existing field

        deletedField = oldValue.diff(newValue)[0]
        OdkFieldSalesforceField.delete(
          mapping_id: $scope.mapping.id
          odk_field_id: $scope.odkFormField.id
          id: deletedField.id
        )

    ########## BEFORE FILTERS

]
