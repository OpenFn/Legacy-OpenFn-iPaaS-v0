'use strict'

@controllerModule.controller 'OdkFormFieldCtrl', ['$scope', '$rootScope',
  '$filter', 'OdkForm', 'OdkFormField',
  ($scope, $rootScope, $filter, OdkForm, OdkFormField) ->

    prepare = () ->
      for sfObj in $scope.mapping.mappedObjects
        for sfField in sfObj.fields
          for odk_field in sfField.odk_fields
            if $scope.odkFormField.field_name == odk_field.field_name
              $scope.odkFormField.sf_fields.push(sfField)

    prepare()

    # currently only checks for one odk field
    odkFieldAlreadyExists = (sfField) ->
      for obj in $scope.mapping.mappedObjects
        if (sfField.object_name == obj.name)
          for field in obj.fields
            if (field.field_name == sfField.field_name)
              return true if field.odk_fields.length != 0

    ########## WATCHES

    $scope.$watch("odkFormField", () ->
      odkField = angular.copy($scope.odkFormField)
      delete odkField.sf_fields

      sfField = $scope.odkFormField.sf_fields[0]
      unless sfField != undefined && odkFieldAlreadyExists(sfField)
        # add sf object first if not there
         

        # push field into its sf object
        for sf_field in $scope.odkFormField.sf_fields
          odk_fields = [odkField]

          for sfObject in $scope.mapping.mappedObjects
            if (sfObject.name == sf_field.object_name)
              for sf_field in sfObject.fields
                for odk_field in odk_fields
                  sf_field.odk_fields.push(odk_field) if sf_field.field_name == sfField.field_name
    , true)
]
