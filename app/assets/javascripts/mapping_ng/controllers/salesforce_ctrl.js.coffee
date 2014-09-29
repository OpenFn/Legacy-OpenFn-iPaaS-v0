'use strict'

@controllerModule.controller 'SalesforceCtrl', ['$scope', '$filter', 'SalesforceObject',
  ($scope, $filter, SalesforceObject) ->

    ########## VARIABLE ASSIGNMENT

    $scope.sfFilter = {}

    ########## FUNCTIONS

    $scope.filterSfFields = (event, ui) ->
      sfObject = $scope.mapping.salesforceObjects.filter((sfObj) ->
        sfObj.color is ui.item.sortable.moved.color
      )[0]

      if $scope.sfFilter
       sfObject.salesforceFields = $filter('filter')(sfObject.originalFields, $scope.sfFilter)
      else
       sfObject.salesforceFields = angular.copy(sfObject.originalFields)

    $scope.prepare = ->
      $scope.sfSortableOptions =
        connectWith: '.sf-connected-sortable'
        revert: true
        opacity: 0.8
        scroll: true
        stop: (event, ui) ->
          $scope.filterSfFields(event, ui)

      for sfObject in $scope.mapping.salesforceObjects
        sfObject.originalFields = angular.copy(sfObject.salesforceFields)

    $scope.toggleRepeat = (salesforceObject) ->
      salesforceObject.is_repeat = !salesforceObject.is_repeat
      SalesforceObject.update(
        mapping_id: $scope.mapping.id
        id: salesforceObject.id
        salesforce_object:
          is_repeat: salesforceObject.is_repeat
      )

    $scope.deleteSfObject = (sfObject) ->
      if confirm("Are you sure you want to remove this object?")
        SalesforceObject.delete(
          mapping_id: $scope.mapping.id,
          id: sfObject.id
        ).$promise.then (response) ->
          i = $scope.mapping.salesforceObjects.indexOf(sfObject)
          $scope.mapping.salesforceObjects.splice(i, 1)

    $scope.setViewingSfObject = (sfObject) ->
      $scope.viewingSfObject = sfObject

    ########## WATCHES

    $scope.$watch "mapping.salesforceObjectName", (salesforceObjectId) ->
      if salesforceObjectId isnt undefined && salesforceObjectId isnt ''
        SalesforceObject.save(
          mapping_id: $scope.mapping.id
          salesforce_object:
            name: salesforceObjectId,
            order: $scope.mapping.salesforceObjects.length + 1
        ).$promise.then (response) ->
          $scope.mapping.salesforceObjects.push(response.salesforce_object)

          # Reset the chosen object name
          $scope.mapping.salesforceObjectName = ''

    $scope.$watch "sfFilter.field_name", (fieldName) ->
      if $scope.viewingSfObject
        if fieldName is ''
          $scope.viewingSfObject.salesforceFields = angular.copy($scope.viewingSfObject.originalFields)
        else
          $scope.viewingSfObject.salesforceFields = $filter('filter')($scope.viewingSfObject.originalFields, $scope.sfFilter)

    ########## BEFORE FILTERS

    $scope.prepare()
]
