class SalesforceObjectFieldsController < ApplicationController

  def index
    mapping = current_user.mappings.find params[:mapping_id]

     sf_client = Restforce.new(
      username: mapping.user.sf_username,
      password: mapping.user.sf_password,
      security_token: mapping.user.sf_security_token,
      client_id: mapping.user.sf_app_key,
      client_secret: mapping.user.sf_app_secret
    )

    sf_fields = sf_client.describe(params[:salesforce_object_id])["fields"]
    render json: sf_fields.collect{|sf_field| {name: sf_field["name"]}}, root: false
  end
end
