@serviceModule.factory 'SalesforceService', ['SalesforceObject', 'SalesforceObjectField',
  (SalesforceObject, SalesforceObjectField) ->

    data = {
      salesforceObjects: []
    }

    salesforceObjects: ->
      data.salesforceObjects

    loadObjects: (callback) ->
      SalesforceObject.query.then (response) ->
        data.salesforceObjects = response.data.salesforce_objects
        callback(data.salesforceObjects)

    loadFields: (salesforceObjectId, callback) ->
      SalesforceObjectField.query(salesforce_object_id: salesforceObjectId).$promise.then (response) ->
          callback(response)

          #$scope.mapping.mappedSfObjects.push sfObject #unless objectAlreadyPushed(sfObject)



]