@resourceModule.factory 'Mapping', ['$resource', ($resource) ->
  $resource "/mappings/:id/:verb", {id: "@id"}
]