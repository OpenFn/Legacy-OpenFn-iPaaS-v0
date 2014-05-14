class OdkFormFieldsController < ApplicationController
  def index
    render json: OdkAggregate::Form.find(params[:odk_form_id]).fields
  end
end