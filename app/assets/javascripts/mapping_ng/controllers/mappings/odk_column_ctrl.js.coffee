'use strict'

@controllerModule.controller 'OdkColumnCtrl', ['$scope', '$rootScope',
  '$filter', 'OdkForm', 'OdkFormField',
  ($scope, $rootScope, $filter, OdkForm, OdkFormField) ->

    ########## VARIABLE ASSIGNMENT

    $scope.odkFilter = {}

    ########## FUNCTIONS

    $scope.getOdkFields = (fieldName) ->
      if fieldName is ''
        $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)
      else
        $scope.odkFormFields = $filter('filter')($scope.originalOdkFormFields, $scope.odkFilter)

    $scope.prepare = ->
      $scope.odkSortableOptions =
        connectWith: '.odk-connected-sortable'
        stop: (event, ui) ->
          $scope.getOdkFields($scope.odkFilter.field_name)

      OdkForm.query.then (response) ->
        $scope.odkForms = response.data.odk_forms
        $scope.itemsLoaded.odkForms = true
        $scope.checkIfLoaded()


    ########## WATCHES

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          $scope.originalOdkFormFields = response
          $scope.odkFormFields = angular.copy($scope.originalOdkFormFields)

    $scope.$watch "odkFilter.field_name", (fieldName) ->
      $scope.getOdkFields(fieldName)

    ########## BEFORE FILTERS
    $scope.prepare()

]
