'use strict'

@controllerModule.controller 'OdkFieldCtrl', ['$scope', '$rootScope', 'OdkFormField', 'OdkFieldSalesforceField', 'SalesforceObjectField',
  ($scope, $rootScope, OdkFormField, OdkFieldSalesforceField, SalesforceObjectField) ->

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
      ).$promise.then () ->
        $scope.$emit "mapping:saved"

    $scope.checkLookupFields = (field) ->
      if field.data_type is 'reference'
        SalesforceObjectField.query(
          mapping_id: $scope.mapping.id
          salesforce_object_id: field.field_name
        ).$promise.then (response) ->
          field.lookupFields = response
          $scope.$emit "mapping:saved"

    $scope.toggleUuid = ->
      for field in $scope.mapping.odk_form.odk_fields
        unless field is $scope.odkFormField
          field.is_uuid = false

      OdkFormField.update(
        mapping_id: $scope.mapping.id,
        id: $scope.odkFormField.id,
        odk_field:
          is_uuid: $scope.odkFormField.is_uuid
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
        ).$promise.then () ->
          $scope.$emit "mapping:saved"
          $scope.checkLookupFields(newField)

      else if newValue.length < oldValue.length
        # Deleting an existing field

        deletedField = oldValue.diff(newValue)[0]
        OdkFieldSalesforceField.delete(
          mapping_id: $scope.mapping.id
          odk_field_id: $scope.odkFormField.id
          id: deletedField.id
        ).$promise.then () ->
          $scope.$emit "mapping:saved"
      else if newValue.length = oldValue.length
        # Initial Load
        newField = newValue[0]
        $scope.checkLookupFields(newField)

    ########## BEFORE FILTERS

]
