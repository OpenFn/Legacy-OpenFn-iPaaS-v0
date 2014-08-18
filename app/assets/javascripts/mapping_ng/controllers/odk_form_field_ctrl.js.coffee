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
    sfMappingAlreadyHasOdkField = (sfField) ->
      for obj in $scope.mapping.mappedObjects
        if (sfField.object_name == obj.name)
          for field in obj.fields
            if (field.field_name == sfField.field_name)
              return false if field.odk_fields.length == 0
              for odk_field in field.odk_fields
                return true if (odk_field.field_name == $scope.odkFormField.field_name)

    sfFieldAlreadyPushed = (object, field) ->
      for obj in $scope.mapping.mappedObjects
        if obj.name == object.name
          for fd in obj.fields
            return true if fd.field_name == field.field_name

    ########## WATCHES

    $scope.$watch("odkFormField", () ->
      odkField = angular.copy($scope.odkFormField)
      delete odkField.sf_fields

      for sfField in $scope.odkFormField.sf_fields
        unless sfMappingAlreadyHasOdkField(sfField)
          for sfObject in $scope.mapping.mappedObjects
            if (sfObject.name == sfField.object_name)

              # of sf field is not already in mapped objects, add it
              unless (sfFieldAlreadyPushed(sfObject, sfField))
                for obj in $scope.mapping.mappedObjects
                  obj.fields.push(sfField) if obj.name == sfObject.name

              for sf_field in sfObject.fields
                sf_field.odk_fields.push(odkField) if sf_field.field_name == sfField.field_name
    , true)

    $scope.toggleDeleteSfObject = () ->
      for sf_field in $scope.odkFormField.sf_fields
        for sfObject in $scope.mapping.mappedObjects
          if (sfObject.name == sf_field.object_name)
            for mapping_sf_field in sfObject.fields
              if mapping_sf_field.field_name == sf_field.field_name
                mapping_sf_field._destroy = !mapping_sf_field._destroy
                $scope._destroy = !$scope._destroy
]
