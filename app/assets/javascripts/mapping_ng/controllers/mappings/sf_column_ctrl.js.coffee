'use strict'

@controllerModule.controller 'SfColumnCtrl', ['$scope', '$filter', 'SalesforceObject',
  'SalesforceObjectField',
  ($scope, $filter, SalesforceObject, SalesforceObjectField) ->

    ########## VARIABLE ASSIGNMENT

    ########## FUNCTIONS

    filterSfFields = () ->
      if $scope.sfFilter
        fieldName == $scope.sfFilter.field_name
      else
        fieldName = ''

      for sfObject in $scope.mapping.mappingSalesforceObjects
        if fieldName == ''
          sfObject.fields = angular.copy(sfObject.originalFields)
        else
          sfObject.fields = $filter('filter')(sfObject.originalFields, $scope.sfFilter)

    $scope.prepare = ->
      $scope.sfSortableOptions =
        connectWith: '.sf-connected-sortable'
        revert: true
        opacity: 0.8
        scroll: true
        #stop: filterSfFields

      SalesforceObject.query.then (response) ->
        $scope.salesforceObjects = response.data.salesforce_objects
        $scope.itemsLoaded.sfForms = true
        $scope.checkIfLoaded()

    objectAlreadyPushed = (object) ->
      for obj in $scope.mapping.mappedSfObjects
        return true if obj.name == object.name

    $scope.updateObject = (sfObject) ->
      SalesforceObjectField.query(salesforce_object_id: sfObject.name).$promise.then (sfFields) ->
        sfObject.fields = sfFields

    colorize = (sfObject) ->
      if (objectAlreadyPushed(sfObject))
        for obj in $scope.mapping.mappedObjects
          if obj.name == sfObject.name
            sfObject.color = obj.fields[0].color
      else
        sfObject.color = $scope.colors.pop()

    ########## WATCHES

    $scope.$watch "mapping.salesforceObjectName", (salesforceObjectId) ->
      if salesforceObjectId isnt undefined

        #sfObject = (i for i in $scope.salesforceObjects when i.name is salesforceObjectId)[0]
        sfObject = $scope.salesforceObjects.filter((sfObj) -> sfObj.name is salesforceObjectId)[0]

        #colorize(sfObject)

        index = $scope.salesforceObjects.indexOf(sfObject)
        $scope.salesforceObjects.splice(index, 1)

        sfObject.fields = []
        sfObject.originalFields = []

        SalesforceObjectField.query(salesforce_object_id: salesforceObjectId).$promise.then (response) ->
          for field in response
            field.color = sfObject.color
            field.object_name = sfObject.name
            field.label_name = sfObject.label
            sfObject.originalFields.push field
            sfObject.fields.push field

          $scope.mapping.mappedSfObjects.push sfObject unless objectAlreadyPushed(sfObject)

      # $scope.$watch("sfFilter.field_name", () ->
      #   filterSfFields() if $scope.mapping.mappingSalesforceObjects
      # )



    ########## BEFORE FILTERS

    $scope.prepare()
]
