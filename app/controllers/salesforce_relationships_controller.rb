class SalesforceRelationshipsController < ApplicationController

  before_action :load_mapping
  before_action :load_salesforce_object

  def create
    @salesforce_relationship = @salesforce_object.salesforce_relationships.new salesforce_relationship_params
    if @salesforce_relationship.save
      render json: @salesforce_relationship
    else
      render json: {errors: @salesforce_relationship.errors.full_messages}, status: 422
    end
  end

  protected

  def load_mapping
    @mapping = current_user.mappings.find params[:mapping_id]
  end

  def load_salesforce_object
    @salesforce_object = @mapping.salesforce_objects.find params[:salesforce_object_id]
  end

  def salesforce_relationship_params
    params.require(:salesforce_relationship).permit(:salesforce_field_id)
  end

end