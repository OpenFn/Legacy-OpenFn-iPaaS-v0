@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    mappingParams: (mapping) ->
      # Add the basic elements to the mapping hash
      hash =
        mapping:
          name: mapping.name
          active: mapping.active
          odk_formid: mapping.odk_formid

      # Create the empty nested attributes for salesforce fields
      hash.mapping.salesforce_fields_attributes = []

      # Loop through our mapping hash
      for sfField in mapping.salesforce_fields

          # Set the SF Field information
          sfFieldAttribute = angular.copy(sfField)

          # Create the empty nested attributes for the odk fields
          sfFieldAttribute.odk_fields_attributes = []

          # Set the odk field information for each field
          sfFieldAttribute.odk_fields_attributes.push angular.copy(odkField) for odkField in sfField.odk_fields

          # Add the sf fields to the main hash
          hash.mapping.salesforce_fields_attributes.push sfFieldAttribute

      hash

    saveMapping: (mapping) ->
      if mapping.id
        Mapping.update {id: mapping.id}, @mappingParams(mapping)
      else
        # Create a mapping using the custom params for nested objects
        Mapping.save {}, @mappingParams(mapping)

]