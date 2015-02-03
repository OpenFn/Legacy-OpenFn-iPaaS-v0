'use strict'

@controllerModule.controller 'LookupObjectCtrl', [
  '$scope',
  '$rootScope',
  '$filter',
  'Mapping',
  'OdkForm',
  'OdkFormField',
  'SalesforceObject',
  'SalesforceObjectField',
  'MappingService',
  (
    $scope,
    $rootScope,
    $filter,
    Mapping,
    OdkForm,
    OdkFormField,
    SalesforceObject,
    SalesforceObjectField,
    MappingService
  ) ->

    prepare = ->
      SalesforceObject.query.then (response) ->
        $scope.salesforceObjects = response.data.salesforce_objects

        if $scope.sfField
          for sfObject in $scope.salesforceObjects
            $scope.currentObject = sfObject if sfObject.name == $scope.sfField.lookup_object

    updateObject = (sfObject) ->
      SalesforceObjectField.query(salesforce_object_id: sfObject.name).$promise.then (sfFields) ->
        sfObject.fields = []
        for field in sfFields
          sfObject.fields.push field

    $scope.$watch("sfField.lookup_object", ->
      if $scope.salesforceObjects
        for sfObject in $scope.salesforceObjects
          if $scope.sfField.lookup_object == sfObject.name
            $scope.currentObject = sfObject
            updateObject(sfObject)
    )

    prepare()
]
