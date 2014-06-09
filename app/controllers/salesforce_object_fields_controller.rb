class SalesforceObjectFieldsController < ApplicationController

  def index
    sf_client = Restforce.new
    sf_fields = sf_client.
      describe(params[:salesforce_object_id])["fields"].
      select{|f| f["updateable"]}.
      collect{|f| {object_name: params[:salesforce_object_id], field_name: f["name"], data_type: f["type"], odk_fields: []}}

    render json: sf_fields, root: false
  end

end