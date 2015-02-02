require 'rails_helper'

RSpec.describe "Example Mapping Submission Integration", :type => :integration do
  
  # The mapping examples are namespaced, rspec can't infer the class/table names
  # from the namespaced fixures.
  def self.mapping_fixture(name)
    [
      Mapping,
      Submission,
      User,
      SalesforceObject,
      SalesforceField,
      SalesforceRelationship,
      OdkField,
      OdkFieldSalesforceField
    ].each { |klass|
      fixtures "#{name}/#{klass.table_name}"
      set_fixture_class "#{name}/#{klass.table_name}" => klass
    }
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
