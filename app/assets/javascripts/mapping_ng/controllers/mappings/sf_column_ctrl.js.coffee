'use strict'

@controllerModule.controller 'SfColumnCtrl', ['$scope', '$filter', 'SalesforceObject',
  'SalesforceObjectField',
  ($scope, $filter, SalesforceObject, SalesforceObjectField) ->

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
          $scope.filterSfFields(event, ui)

      SalesforceObject.query.then (response) ->
        $scope.salesforceObjects = response.data.salesforce_objects
        $scope.itemsLoaded.sfForms = true
        $scope.checkIfLoaded()

    objectAlreadyPushed = (object) ->
      for obj in $scope.mapping.mappedSfObjects
        return true if obj.name is object.name

    $scope.updateObject = (sfObject) ->
      unless sfObject.fields
        sfObject.fields = []
        sfObject.originalFields = []
        SalesforceObjectField.query(salesforce_object_id: sfObject.name).$promise.then (sfFields) ->
          for f in sfFields
            f.color = sfObject.color
            sfObject.fields.push f
            sfObject.originalFields.push f


    colorize = (sfObject) ->
      # if (objectAlreadyPushed(sfObject))
      #   for obj in $scope.mapping.mappedObjects
      #     if obj.name is sfObject.name
      #       sfObject.color = obj.fields[0].color
      # else
      sfObject.color = $scope.colors.pop()

    ########## WATCHES

    $scope.$watch "mapping.salesforceObjectName", (salesforceObjectId) ->
      if salesforceObjectId isnt undefined && salesforceObjectId isnt ''
        sfObject = angular.copy($scope.salesforceObjects.filter((sfObj) -> sfObj.name is salesforceObjectId)[0])

        colorize(sfObject)

        mapping.salesforceObjectName = ''

        #index = $scope.salesforceObjects.indexOf(sfObject)
        #$scope.salesforceObjects.splice(index, 1)

        sfObject.fields = []
        sfObject.originalFields = []

        SalesforceObjectField.query(salesforce_object_id: salesforceObjectId).$promise.then (response) ->
          for field in response
            field.color = sfObject.color
            field.object_name = sfObject.name
            field.label_name = sfObject.label
            sfObject.originalFields.push field
            sfObject.fields.push field

          $scope.mapping.mappedSfObjects.push sfObject #unless objectAlreadyPushed(sfObject)

      # $scope.$watch("sfFilter.field_name", () ->
      #   filterSfFields() if $scope.mapping.mappedSfObjects.length > 0
      # )



    ########## BEFORE FILTERS

    $scope.prepare()
]
