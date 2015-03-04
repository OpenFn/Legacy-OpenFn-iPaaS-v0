module OdkSfLegacy
  class OdkFieldsController < ApplicationController
    def index
      odk = OdkAggregate::Connection.new(current_user.odk_url,
                                         current_user.odk_username,
                                         current_user.odk_password)
      odk_form_fields = odk.find_form(params[:odk_form_id]).fields.
        collect do |f|
          index = f["nodeset"].index("/", 1)
          {field_name: f["nodeset"][index..-1], field_type: f["type"], salesforceFields: []}
        end

      render json: odk_form_fields, root: false
    end

    def update
      @mapping = current_user.mappings.find(params[:mapping_id])
      @odk_field = @mapping.odk_form.odk_fields.find(params[:id])
      if @odk_field.update(odk_field_params)
        render json: @odk_field
      else
        render json: {errors: @odk_field.errors.full_messages}, status: 422
      end
    end

    protected

    def odk_field_params
      params.require(:odk_field).permit(:is_uuid)
    end
  end
end
