'use strict'

@controllerModule.controller 'SalesforceCtrl', ['$scope', '$filter', 'SalesforceObject',
  ($scope, $filter, SalesforceObject) ->

    ########## VARIABLE ASSIGNMENT

    ########## FUNCTIONS

    $scope.filterSfFields = (event, ui) ->

      sfObject = $scope.mapping.mappedSfObjects.filter((sfObj) -> sfObj.name is ui.item.sortable.moved.object_name)[0]

      if $scope.sfFilter
        sfObject.fields = $filter('filter')(sfObject.originalFields, $scope.sfFilter)
      else
        sfObject.fields = angular.copy(sfObject.originalFields)

    $scope.prepare = ->
      $scope.sfSortableOptions =
        connectWith: '.sf-connected-sortable'
        revert: true
        opacity: 0.8
        scroll: true
        stop: (event, ui) ->

    $scope.toggleRepeat = (salesforceObject) ->
      salesforceObject.is_repeat = !salesforceObject.is_repeat
      SalesforceObject.update(
        mapping_id: $scope.mapping.id
        id: salesforceObject.id
        salesforce_object:
          is_repeat: salesforceObject.is_repeat
      )

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


    ########## BEFORE FILTERS

    $scope.prepare()
]
