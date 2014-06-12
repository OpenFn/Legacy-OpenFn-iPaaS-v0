'use strict'

@controllerModule.controller 'SfColumnCtrl', ['$scope', 'SalesforceObject', 'SalesforceObjectField',
  ($scope, SalesforceObject, SalesforceObjectField) ->

    ########## VARIABLE ASSIGNMENT

    ########## FUNCTIONS

    $scope.prepare = ->
      $scope.sfSortableOptions =
        connectWith: '.sf-connected-sortable'

      SalesforceObject.query.then (response) ->
        $scope.salesforceObjects = response.data.salesforce_objects

    $scope.toggleDeleteSfObject = (sfObject) ->
      sfObject._destroy = !sfObject._destroy

    $scope.updateObject = (sfObject) ->
      SalesforceObjectField.query(salesforce_object_id: sfObject.name).$promise.then (sfFields) ->

        for field in sfFields
          # Check if the sfObject has this field
          objs = sfObject.fields.filter (sfField) -> sfField.field_name is field.field_name
          if objs.length is 0

            # If it doesn't, add it to the array
            sfObject.fields.push field


    ########## WATCHES

    $scope.$watch "mapping.salesforceObjectName", (salesforceObjectId) ->
      if salesforceObjectId isnt undefined

        sfObject = (i for i in $scope.salesforceObjects when i.name is salesforceObjectId)[0]
        index = $scope.salesforceObjects.indexOf(sfObject)
        $scope.salesforceObjects.splice(index, 1)

        SalesforceObjectField.query(salesforce_object_id: salesforceObjectId).$promise.then (response) ->
          sfObject.fields = response
          $scope.mapping.mappingSalesforceObjects.push sfObject


    ########## BEFORE FILTERS

    $scope.prepare()
]