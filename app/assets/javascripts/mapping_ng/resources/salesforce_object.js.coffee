@resourceModule.factory 'SalesforceObject', ['$http', ($http) ->
  query: $http.get('/salesforce_objects')
]

