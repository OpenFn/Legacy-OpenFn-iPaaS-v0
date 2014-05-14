@resourceModule.factory 'OdkForm', ['$http', ($http) ->
  query: $http.get('/odk_forms')
]

