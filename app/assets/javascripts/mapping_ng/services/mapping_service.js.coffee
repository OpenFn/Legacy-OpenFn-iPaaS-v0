@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    reverseMapping: (mapping) ->
      mapping.mappingSalesforceObjects = []

      # Load the mapping salesforce fields and create
      # a combined object so that all the fields are
      # under their proper tab
      m = mapping.salesforce_fields.reduce (hash, obj) ->

        h = {
          name: obj.object_name
          label: obj.label_name
          color: obj.color
        }

        # Use the object and name as the key
        hash[JSON.stringify(h)] ||= []

        # put the objects with the same SF parent in the proper hash
        hash[JSON.stringify(h)].push obj
        hash
      , {}

      # load the key and value for the reduced hash
      for hsh, value of m

        # The object fields are the hash key
        hsh = JSON.parse(hsh)

        #if no colors, colorize
        unless hsh.color
          hsh.color = mapping.colors.pop()

        # the ODK fields are the value which is an array
        fields = []
        for field in value
          field.color = hsh.color unless field.color
          fields.push field

        hsh.fields = fields

        # Set the perform lookups based on the first object
        hsh.perform_lookups = hsh.fields[0] && hsh.fields[0].perform_lookups

        # push that into the mapping SF object
        mapping.mappingSalesforceObjects.push hsh
        mapping.mappedObjects = angular.copy(mapping.mappingSalesforceObjects)

      mapping

    mappingParams: (mapping) ->
      # Add the basic elements to the mapping hash

      sfObjects = mapping.mappedObjects
      delete mapping.mappedObjects

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
            color: sfField.color
            _destroy: sfField._destroy
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
