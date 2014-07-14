class SalesforceObjectFieldsController < ApplicationController

  def index
    sf_client = Restforce.new(username: current_user.sf_username,
                              password: current_user.sf_password,
                              security_token: current_user.sf_security_token,
                              client_id: current_user.sf_app_key,
                              client_secret: current_user.sf_app_secret)
    sf_fields = sf_client.
      describe(params[:salesforce_object_id])["fields"].
      select{|f| f["updateable"]}.
      collect{|f| {object_name: params[:salesforce_object_id], field_name: f["name"], data_type: f["type"], odk_fields: []}}

    render json: sf_fields, root: false
  end
end
