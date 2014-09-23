@resourceModule.factory 'SalesforceObject', ['$resource', ($resource) ->
  $resource "/mappings/:mapping_id/salesforce_objects/:id", {mapping_id: "@mapping_id", id: "@id"},
    update:
      method: "PUT"
]