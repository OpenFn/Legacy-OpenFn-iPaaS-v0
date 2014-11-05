@resourceModule.factory 'OdkFormField', ['$resource', ($resource) ->
  $resource "/mappings/:mapping_id/odk_fields/:id", {mapping_id: "@mapping_id", id: "@id"},
    update:
      method: "PUT"
]