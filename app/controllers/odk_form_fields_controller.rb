class OdkFormFieldsController < ApplicationController
  def index
    odk_form_fields = OdkAggregate::Form.find(params[:odk_form_id]).fields.
      collect do |f|
        index = f["nodeset"].index("/", 1)
        {field_name: f["nodeset"][index..-1], field_type: f["type"]}
      end

    render json: odk_form_fields, root: false
  end
end