@OpenFnServices.factory 'ConnectionProfiles', ($http) ->
  @fetch = (type) ->
    return $http.get("/api/v1/connection_profiles?type=#{type}")
    .success (results) ->
      return results
    .error (err) ->
      console.error(err)
      return []

  @fetchSources = =>
    @fetch 'source'

  @fetchDestinations = =>
    @fetch 'destination'

  @save = (obj) ->
    return $http.post('/api/v1/connection_profiles', { connection_profile: obj })
    .success (results) ->
      return results.data
    .error (err) ->
      console.error(err)
      return null

  return fetchSources: @fetchSources, fetchDestinations: @fetchDestinations, save: @save
