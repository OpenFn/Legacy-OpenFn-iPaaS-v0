@serviceModule.factory 'OdkService', ['OdkForm', 'OdkFormField'
  (OdkForm, OdkFormField) ->
    data = {
      odkForms: []
    }

    getOdkForms: ->
      data.odkForms

    loadForms: (callback) ->
      OdkForm.query.then (response) =>
        data.odkForms = response.data.odk_forms
        callback(@getOdkForms())

    loadFields: (formId, callback) ->
      odkFields = []
      OdkFormField.query(odk_form_id: formId).$promise.then (response) =>
        for odkField in response
          odkFields.push @setFieldDisplayOptions(odkField)

        callback(odkFields)
        # existingField = $scope.mapping.odkFormFields.filter((mOdkField) -> mOdkField.field_name is odkField.field_name)[0]
        # if existingField
        #   $
        # else
        #   $scope.mapping.odkFormFields.push $scope.setFieldDisplayOptions(odkField)


    setFieldDisplayOptions: (odkFormField) ->
      arr = odkFormField.field_name.split("/")
      odkFormField.displayName = arr[arr.length - 1]

      if arr.length > 2
        odkFormField.displayStyle = {paddingLeft: "#{(arr.length - 1) * 2}0px"}

      odkFormField
]