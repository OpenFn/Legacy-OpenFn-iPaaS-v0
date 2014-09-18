@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    mappingParams: (mapping) ->
      # Add the basic elements to the mapping hash
      hash =
        mapping:
          name: mapping.name
          active: mapping.active
          odkForm: {
            name: mapping.odkForm.name
            odk_fields_attributes: []
          }

      # Create the empty nested attributes for salesforce fields
      hash.mapping.salesforce_objects_attributes = []

      # Loop through all the objects in the mapping
      for odkField in mapping.odkForm.odkFields
        odkField.salesforce_fields_attributes = []

        # Loop through all the fields in these objects
        for sfField in odkField.salesforceFields
          odkField.salesforce_fields_attributes.push sfField

        hash.mapping.odkForm.odk_fields_attributes.push odkField

      hash

    saveMapping: (mapping) ->
      if mapping.id
        Mapping.update {id: mapping.id}, @mappingParams(mapping)
      else
        # Create a mapping using the custom params for nested objects
        #Mapping.save {}, @mappingParams(mapping)
        console.log @mappingParams(mapping)

]
