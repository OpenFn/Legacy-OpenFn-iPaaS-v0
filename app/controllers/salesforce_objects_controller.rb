class SalesforceObjectsController < ApplicationController

  before_action :load_mapping

  def create
    salesforce_object = @mapping.salesforce_objects.new(salesforce_object_params)
    if salesforce_object.save
      render json: salesforce_object
    else
      render json: {errors: salesforce_object.errors.full_messages}, status: 422
    end
  end

  protected

  def load_mapping
    @mapping = current_user.mappings.find params[:mapping_id]
  end

  def salesforce_object_params
    params.require(:salesforce_object).permit(:name, :label)
  end

end
