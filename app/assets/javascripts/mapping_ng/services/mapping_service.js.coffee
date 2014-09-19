@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    mappingParams: (mapping) ->
      hash = {
        mapping: {
          name: mapping.name
          active: mapping.active
          odk_form_attributes: mapping.odkForm
        }
      }

    saveMapping: (mapping) ->
      if mapping.id
        Mapping.update {id: mapping.id}, @mappingParams(mapping)
      else
        # Create a mapping using the custom params for nested objects
        Mapping.save {}, @mappingParams(mapping)
]
