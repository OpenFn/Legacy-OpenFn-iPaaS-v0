class OdkFormsController < ApplicationController

  def index
    odk_forms = OdkAggregate::Form.all.collect(&:form_id).sort
    render json: odk_forms
  end

end