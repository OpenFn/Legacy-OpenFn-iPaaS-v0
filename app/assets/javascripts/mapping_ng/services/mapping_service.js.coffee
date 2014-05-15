@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->
    mapping = {}

    updateMapping: (salesforceObjectName, salesforceObjectFields) ->
      mapping[salesforceObjectName] = salesforceObjectFields

    getMappingForSalesForce: (salesforceObjectName) ->
      mapping[salesforceObjectName]

    mappingParams: (mappingName, odkFormId) ->
      # Add the basic elements to the mapping hash
      hash =
        mapping:
          name: mappingName
          odk_formid: odkFormId

      # Create the empty nested attributes for salesforce fields
      hash.mapping.salesforce_fields_attributes = []

      # Loop through our mapping hash
      for sfObject, sfFields of mapping

        # Loop through the fields for the SF Object
        for sfField in sfFields

          # Set the SF Field information
          sfFieldAttribute = {object_name: sfObject, field_name: sfField.name}

          # Create the empty nested attributes for the odk fields
          sfFieldAttribute.odk_fields_attributes = []

          # Set the odk field information for each field
          sfFieldAttribute.odk_fields_attributes.push {field_name: odkField.nodeset, field_type: odkField.type} for odkField in sfField.odk_fields

          # Add the sf fields to the main hash
          hash.mapping.salesforce_fields_attributes.push sfFieldAttribute

      hash

    saveMapping: (mappingName, odkFormId) ->
      # Create a mapping using the custom params for nested objects
      Mapping.save({}, @mappingParams(mappingName, odkFormId))
]