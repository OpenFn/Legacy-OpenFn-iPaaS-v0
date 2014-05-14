@resourceModule.factory 'SalesforceObjectField', ['$resource', ($resource) ->
  $resource "/salesforce_objects/:salesforce_object_id/salesforce_object_fields", {salesforce_object_id: "@salesforce_object_id"}
]