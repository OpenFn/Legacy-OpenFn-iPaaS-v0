@resourceModule.factory 'SalesforceObjectField', ['$resource', ($resource) ->
  $resource "/mappings/:mapping_id/salesforce_objects/:salesforce_object_id/salesforce_object_fields",
    {
      mapping_id: "@mapping_id"
      salesforce_object_id: "@salesforce_object_id"
    }
]