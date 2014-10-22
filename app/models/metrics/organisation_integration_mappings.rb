# Simple Data Transfer object to represent the OrganisationIntegrationMapping 
# structure for metrics. Explicit properties and simple #to_json methods create
# a json resource structure not yet backed by the data schema, and seperates the
# business domain from the database implementation.

# This is very simple and explicit right now because there is as yet no 
# underlying structure to back it up.
class Metrics::OrganisationIntegrationMappings
  attr_reader :organisation_name, :integration_mappings

  def self.all
    User.all.map do |user|
      self.for_user(user)
    end
  end

  # Will become .for_organisation, and expand to support multiple integrations
  def self.for_user(user)
    self.new(user.email, [IntegrationMapping.new('SalesForce - ODK', user.mappings)])
  end

  # Factory methods like .all and .for_user are separated from the constructor to allow
  # the Organisation implementation to develop without impacting this Data Transfer Object.
  # .for_user would become .for_organisation, and .all would need to change to map through
  # Organisation.all, while the instances themselves remain unaffected.
  def initialize(organisation_name, integration_mappings)
    @organisation_name = organisation_name
    @integration_mappings = integration_mappings
  end

  def to_json
    {
      organisation_name: organisation_name,
      integrations: integration_mappings
    }.to_json
  end

  class IntegrationMapping
    attr_reader :integration_name, :mappings

    def initialize(integration_name, mappings)
      @integration_name = integration_name
      @mappings = mappings
    end

    def to_json
      {
        integration_name: integration_name,
        mappings: mappings.map(&:name)
      }
    end

  end
end