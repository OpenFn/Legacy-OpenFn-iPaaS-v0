class SalesforceObjectFieldsController < ApplicationController

  def index
    #sf_client = Restforce.new
    #sf_fields = sf_client.describe("#{params[:salesforce_object_id]}__c")["fields"].select{|f| f["updateable"]}.collect{|f| {name: f["name"]}}
    #render json: sf_fields
    render json: [{name: "Name", odk_fields: []}, {name: "Foo", odk_fields: []}, {name: "Bar", odk_fields: []}]
  end

end