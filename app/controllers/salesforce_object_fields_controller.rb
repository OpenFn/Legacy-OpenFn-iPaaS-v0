class SalesforceObjectFieldsController < ApplicationController

  # Retrieve a list of Salesforce fields.
  # Used to set the lookup field when creating a relationship mapping.
  def index
    mapping = current_user.mappings.find params[:mapping_id]
    sf_client = RestforceService.new(current_user).connection
    sf_fields = sf_client.describe(params[:salesforce_object_id])["fields"]
    render json: sf_fields.collect{|sf_field| {name: sf_field["name"]}}, root: false
  end
end
