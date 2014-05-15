@resourceModule.factory 'Mapping', ['$resource', ($resource) ->
  $resource "/mappings/:id", {id: "@id"},
    update:
      method: "PUT"
]