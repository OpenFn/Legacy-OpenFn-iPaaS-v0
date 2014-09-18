'use strict'

@controllerModule.controller 'OdkColumnCtrl', ['$scope', '$rootScope', '$filter', 'OdkService'
  ($scope, $rootScope, $filter, OdkService) ->

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

      OdkService.loadForms (forms) ->
        $scope.odkForms = forms
        $scope.itemsLoaded.odkForms = true
        $scope.checkIfLoaded()

    ########## WATCHES

    $scope.$watch "mapping.odk_formid", (formId) ->
      if formId isnt undefined
        $scope.mapping.odkForm = {
          name: formId,
          odkFields: []
        }

        OdkService.loadFields formId, (fields) ->
          $scope.mapping.odkForm.odkFields = fields

    ########## BEFORE FILTERS
    $scope.prepare()

]
