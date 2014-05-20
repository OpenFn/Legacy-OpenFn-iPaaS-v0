class OdkFormFieldsController < ApplicationController
  def index
    odk_form_fields = OdkAggregate::Form.find(params[:odk_form_id]).fields.
      collect{|f| {field_name: f["nodeset"], field_type: f["type"]}}

    render json: odk_form_fields, root: false
  end
end