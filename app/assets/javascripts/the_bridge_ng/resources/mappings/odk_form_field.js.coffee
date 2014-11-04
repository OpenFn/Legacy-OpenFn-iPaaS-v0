@resourceModule.factory 'OdkFormField', ['$resource', ($resource) ->
  $resource "/odk_forms/:odk_form_id/odk_fields/:id", {odk_form_id: "@odk_form_id", id: "@id"}
]