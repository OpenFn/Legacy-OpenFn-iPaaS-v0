@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    mappingParams: (mapping) ->
      # Add the basic elements to the mapping hash
      #sfObjects = mapping.mappedObjects
      #delete mapping.mappedObjects

      hash =
        mapping:
          name: mapping.name
          active: mapping.active
          odk_formid: mapping.odk_formid

      # Create the empty nested attributes for salesforce fields
      hash.mapping.salesforce_fields_attributes = []

      # Loop through all the objects in the mapping
      for odkField in mapping.odkFormFields

        # Loop through all the fields in these objects
        for sfField in odkField.sf_fields

          sfObject = mapping.mappedSfObjects.filter((sfObj) -> sfObj.name is sfField.object_name)[0]

          # Set the SF Field information
          sfFieldAttribute = {
            id: sfField.id
            object_name: sfObject.name
            label_name: sfObject.label
            data_type: sfField.data_type
            field_name: sfField.field_name
            is_lookup: sfField.is_lookup
            lookup_object: sfField.lookup_object
            lookup_field: sfField.lookup_field
            color: sfField.color
            _destroy: sfField._destroy
          }

          # Create the empty nested attributes for the odk fields
          sfFieldAttribute.odk_fields_attributes = []

          # Set the odk field information for each field
          sfFieldAttribute.odk_fields_attributes.push {
            id: odkField.id
            field_name: odkField.field_name
            field_type: odkField.field_type
            _destroy: odkField._destroy
          }

          # Add the sf fields to the main hash
          hash.mapping.salesforce_fields_attributes.push sfFieldAttribute
      debugger
      hash

    saveMapping: (mapping) ->
      if mapping.id
        Mapping.update {id: mapping.id}, @mappingParams(mapping)
      else
        # Create a mapping using the custom params for nested objects
        Mapping.save {}, @mappingParams(mapping)

]
