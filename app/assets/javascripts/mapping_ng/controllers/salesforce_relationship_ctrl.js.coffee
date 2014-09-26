'use strict'

@controllerModule.controller 'SalesforceRelationshipCtrl', ['$scope', '$rootScope', 'SalesforceRelationship',
  ($scope, $rootScope, SalesforceRelationship) ->

    ########## VARIABLE ASSIGNMENT

    ########## FUNCTIONS

    $scope.deleteField = (sfField) ->
      i = $scope.odkFormField.salesforceFields.indexOf(sfField)
      $scope.odkFormField.salesforceFields.splice(i, 1)

    ########## WATCHES

    $scope.$watchCollection "salesforceObject.relationshipFields", (newValue, oldValue) ->
      if newValue.length > oldValue.length
        # Adding a new field
        newField = newValue.diff(oldValue)[0]

        SalesforceRelationship.save(
          mapping_id: $scope.mapping.id
          salesforce_object_id: $scope.salesforceObject.id
          salesforce_relationship:
            salesforce_field_id: newField.id
        )

      else if newValue < oldValue
        # Deleting an existing field

        deletedField = oldValue.diff(newValue)[0]
        SalesforceRelationship.delete(
          mapping_id: $scope.mapping.id
          salesforce_field_id: $scope.salesforceObject.id
          id: deletedField.id
        )

    ########## BEFORE FILTERS

]
