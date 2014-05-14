@resourceModule.factory 'OdkFormField', ['$resource', ($resource) ->
  $resource "/odk_forms/:odk_form_id/odk_form_fields", {odk_form_id: "@odk_form_id"}
]