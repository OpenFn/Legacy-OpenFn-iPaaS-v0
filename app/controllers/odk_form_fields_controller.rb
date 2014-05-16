class OdkFormFieldsController < ApplicationController
  def index
    raise OdkAggregate::Form.find(params[:odk_form_id]).fields.inspect
    render json: OdkAggregate::Form.find(params[:odk_form_id]).fields.
      collect{|f| {field_name: f["nodeset"], field_type: f["type"]}}
  end
end