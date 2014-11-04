@resourceModule.factory 'SalesforceRelationship', ['$resource', ($resource) ->
  $resource "/mappings/:mapping_id/salesforce_objects/:salesforce_object_id/salesforce_relationships/:id",
    {mapping_id: "@mapping_id", salesforce_object_id: "@salesforce_object_id", id: "@id"},
    update:
      method: "PUT"
]