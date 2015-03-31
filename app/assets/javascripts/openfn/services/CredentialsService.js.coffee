@OpenFnServices.factory "CredentialsService", ($http) ->
  @create = (attrs) ->
    return $http.post('/api/v1/credentials', credential: attrs)

  {
    create: @create
  }