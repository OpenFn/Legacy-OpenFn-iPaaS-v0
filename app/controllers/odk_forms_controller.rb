class OdkFormsController < ApplicationController

  def index
    odk = OdkAggregate::Connection.new(current_user.odk_url)
    odk_forms = odk.all_forms.collect(&:form_id).sort
    render json: odk_forms
  end

end
