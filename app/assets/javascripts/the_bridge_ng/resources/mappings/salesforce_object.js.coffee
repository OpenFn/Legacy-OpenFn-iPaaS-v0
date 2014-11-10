@resourceModule.factory 'SalesforceObject', ['$resource', ($resource) ->
  $resource "/mappings/:mapping_id/salesforce_objects/:id/:action", {mapping_id: "@mapping_id", id: "@id"},
    update:
      method: "PUT"

    refreshFields:
      method: "GET"
      params:
        action: 'refresh_fields'
]