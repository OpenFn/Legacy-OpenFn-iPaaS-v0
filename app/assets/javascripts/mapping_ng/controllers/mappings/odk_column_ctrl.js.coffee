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

    ########## WATCHES

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        OdkFormField.query(odk_form_id: formId).$promise.then (response) ->
          for odkField in response
            unless $scope.mapping.odkFormFields.filter((mOdkField) -> mOdkField.field_name is odkField.field_name).length > 0
              $scope.mapping.odkFormFields.push odkField


    # $scope.$watch "odkFilter.field_name", (fieldName) ->
    #   $scope.getOdkFields(fieldName)

    ########## BEFORE FILTERS
    $scope.prepare()

]
