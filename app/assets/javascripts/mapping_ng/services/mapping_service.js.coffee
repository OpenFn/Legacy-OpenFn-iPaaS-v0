@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    reverseMapping: (mapping) ->
      mapping.mappingSalesforceObjects = []

      m = mapping.salesforce_fields.reduce (hash, obj) ->
        h = {
          name: obj.object_name
          label: obj.label_name
        }
        hash[JSON.stringify(h)] ||= []
        hash[JSON.stringify(h)].push obj
        hash
      , {}

      for hsh, value of m
        hsh = JSON.parse(hsh)
        hsh.fields = value
        mapping.mappingSalesforceObjects.push hsh

      mapping

    mappingParams: (mapping) ->
      # Add the basic elements to the mapping hash

      sfObjects = mapping.mappingSalesforceObjects
      delete mapping.mappingSalesforceObjects

      hash =
        mapping:
          name: mapping.name
          active: mapping.active
          odk_formid: mapping.odk_formid

      # Create the empty nested attributes for salesforce fields
      hash.mapping.salesforce_fields_attributes = []

      # Loop through all the objects in the mapping
      for sfObject in sfObjects

        # Loop through all the fields in these objects
        for sfField in sfObject.fields

          # Set the SF Field information
          sfFieldAttribute = {
            id: sfField.id
            object_name: sfObject.name
            label_name: sfObject.label
            data_type: sfField.data_type
            field_name: sfField.field_name
            perform_lookups: sfObject.perform_lookups
            _destroy: sfObject._destroy
          }

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