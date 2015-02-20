class Metrics::OrganisationIntegrationMappingsController < ApplicationController
  respond_to :json
  layout false

  before_filter :set_organisation_mappings

  def index
    render json: @organisation_mappings.to_json
  end

  def set_organisation_mappings
    @organisation_mappings = Metrics::OdkSfLegacy::OrganisationIntegrationMappings.all
  end
end
