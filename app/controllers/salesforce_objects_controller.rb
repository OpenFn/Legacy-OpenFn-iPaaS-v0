class SalesforceObjectsController < ApplicationController

  before_action :load_mapping
  before_action :load_salesforce_object, only: [:update, :destroy, :refresh_fields]

  def create
    salesforce_object = @mapping.salesforce_objects.new(salesforce_object_params)
    if salesforce_object.save
      render json: salesforce_object
    else
      render json: {errors: salesforce_object.errors.full_messages}, status: 422
    end
  end

  def update
    if @salesforce_object.update(salesforce_object_params)
      render json: @salesforce_object
    else
      render json: {errors: @salesforce_object.errors.full_messages}, status: 422
    end
  end

  def destroy
    if @salesforce_object.destroy
      render json: true
    else
      render json: {errors: @salesforce_object.errors.full_messages}, status: 422
    end
  end

  def refresh_fields
    if @salesforce_object.create_fields_from_salesforce
      render json: @salesforce_object.reload
    else
      render json: {errors: @salesforce_object.errors.full_messages}, status: 422
    end
  end

  protected

  def load_mapping
    @mapping = current_user.mappings.find params[:mapping_id]
  end

  def load_salesforce_object
    @salesforce_object = @mapping.salesforce_objects.find params[:id]
  end


  def salesforce_object_params
    params.require(:salesforce_object).permit(:name, :label, :order, :is_repeat)
  end

end
