'use strict'

@controllerModule.controller 'OdkColumnCtrl', ['$scope', '$rootScope',
  '$filter', 'OdkForm', 'OdkFormField',
  ($scope, $rootScope, $filter, OdkForm, OdkFormField) ->

    ########## VARIABLE ASSIGNMENT

    $scope.odkFilter = {}

    ########## FUNCTIONS

    # $scope.getOdkFields = (fieldName) ->
    #   if fieldName is ''
    #     $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)
    #   else
    #     $scope.odkFormFields = $filter('filter')($scope.originalOdkFormFields, $scope.odkFilter)

    $scope.prepare = ->
      $scope.odkSortableOptions =
        connectWith: '.odk-connected-sortable'
        stop: (event, ui) ->
          debugger
          #$scope.getOdkFields($scope.odkFilter.field_name)

      OdkForm.query.then (response) ->
        $scope.odkForms = response.data.odk_forms
        $scope.itemsLoaded.odkForms = true
        $scope.checkIfLoaded()

    $scope.setFieldDisplayOptions = (odkFormField) ->
      arr = odkFormField.field_name.split("/")
      odkFormField.displayName = arr[arr.length - 1]

      if arr.length > 2
        odkFormField.displayStyle = {paddingLeft: "#{(arr.length - 1) * 2}0px"}

      odkFormField

    ########## WATCHES

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          for odkField in response
            existingField = $scope.mapping.odkFormFields.filter((mOdkField) -> mOdkField.field_name is odkField.field_name)[0]
            if existingField
              $scope.setFieldDisplayOptions(existingField)
            else
              $scope.mapping.odkFormFields.push $scope.setFieldDisplayOptions(odkField)

    # $scope.$watch "odkFilter.field_name", (fieldName) ->
    #   $scope.getOdkFields(fieldName)

    ########## BEFORE FILTERS
    $scope.prepare()

]
