@resourceModule.factory 'OdkFieldSalesforceField', ['$resource', ($resource) ->
  $resource "/mappings/:mapping_id/odk_fields/:odk_field_id/odk_field_salesforce_fields/:id", {
    mapping_id: "@mapping_id",
    odk_field_id: "@odk_field_id",
    id: "@id"
  },
  update:
    method: "PUT"
]