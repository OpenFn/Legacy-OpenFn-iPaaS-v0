@serviceModule.factory 'MappingService', ['Mapping'
  (Mapping) ->

    mappingParams: (mapping) ->
      hash = {
        mapping: {
          name: mapping.name
          active: mapping.active
          enabled: mapping.enabled
          odk_form_attributes: mapping.odkForm
          can_be_enabled: mapping.can_be_enabled
        }
      }

    saveMapping: (mapping) ->
      if mapping.id
        Mapping.update {id: mapping.id}, @mappingParams(mapping)
      else
        # Create a mapping using the custom params for nested objects
        Mapping.save {}, @mappingParams(mapping)
]
