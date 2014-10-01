class OdkFieldSalesforceFieldsController < ApplicationController

  before_action :load_mapping
  before_action :load_odk_field

  def create
    @odk_field_salesforce_field = @odk_field.odk_field_salesforce_fields.new salesforce_field_params
    if @odk_field_salesforce_field.save
      render json: @odk_field_salesforce_field
    else
      render json: {errors: @odk_field_salesforce_field.errors.full_messages}, status: 422
    end
  end

  def destroy
    @odk_field_salesforce_field = @odk_field.odk_field_salesforce_fields.find_by(salesforce_field_id: params[:id])
    if @odk_field_salesforce_field.destroy
      render json: true
    else
      render json: {errors: @odk_field_salesforce_field.errors.full_messages}, status: 422
    end
  end

  def update
    @odk_field_salesforce_field = @odk_field.odk_field_salesforce_fields.find_by(salesforce_field_id: params[:id])
    if @odk_field_salesforce_field.update(salesforce_field_params)
      render json: true
    else
      render json: {errors: @odk_field_salesforce_field.errors.full_messages}, status: 422
    end
  end

  protected

  def load_mapping
    @mapping = current_user.mappings.find params[:mapping_id]
  end

  def load_odk_field
    @odk_field = @mapping.odk_fields.find params[:odk_field_id]
  end

  def salesforce_field_params
    params.require(:odk_field_salesforce_field).permit(:salesforce_field_id, :lookup_field_name)
  end

end