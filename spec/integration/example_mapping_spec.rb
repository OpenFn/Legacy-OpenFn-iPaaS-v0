require 'rails_helper'

RSpec.describe "Example Mapping Submission Integration", :type => :integration do
  
  # The mapping examples are namespaced, rspec can't infer the class/table names
  # from the namespaced fixures.
  def self.mapping_fixture(name)
    fixtures "#{name}/mappings"
    set_fixture_class "#{name}/mappings" => Mapping
    fixtures "#{name}/submissions"
    set_fixture_class "#{name}/submissions" => Submission
    fixtures "#{name}/users"
    set_fixture_class "#{name}/users" => User
    fixtures "#{name}/salesforce_objects"
    set_fixture_class "#{name}/salesforce_objects" => SalesforceObject
    fixtures "#{name}/salesforce_fields"
    set_fixture_class "#{name}/salesforce_fields" => SalesforceField
    fixtures "#{name}/salesforce_relationships"
    set_fixture_class "#{name}/salesforce_relationships" => SalesforceRelationship
    fixtures "#{name}/odk_fields"
    set_fixture_class "#{name}/odk_fields" => OdkField
    fixtures "#{name}/odk_field_salesforce_fields"
    set_fixture_class "#{name}/odk_field_salesforce_fields" => OdkFieldSalesforceField
  end

  mapping_fixture('complex_survey')

  describe OdkToSalesforce::SubmissionProcessor do
    let(:mapping_id) { Mapping.first.id }
    let(:submission_id) { Submission.first.id }
    subject { described_class.new.perform(mapping_id,submission_id) }

    it "creates a object on Salesforce" do
      VCR.use_cassette("complex_survey", record: :new_episodes) do
        subject
      end
    end
    
  end
end
