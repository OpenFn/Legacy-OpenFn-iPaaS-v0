require 'rails_helper'

RSpec.describe "Mapping Submission with Nested Repeat Blocks", :type => :integration do
  
  # The mapping examples are namespaced, rspec can't infer the class/table names
  # from the namespaced fixures.
  def self.mapping_fixture(name)
    [
      OdkSfLegacy::Mapping,
      OdkSfLegacy::Submission,
      User,
      OdkSfLegacy::SalesforceObject,
      OdkSfLegacy::SalesforceField,
      OdkSfLegacy::SalesforceRelationship,
      OdkSfLegacy::OdkField,
      OdkSfLegacy::OdkFieldSalesforceField
    ].each { |klass|
      fixtures "#{name}/#{klass.table_name}"
      set_fixture_class "#{name}/#{klass.table_name}" => klass
    }
  end

  mapping_fixture('nested_test_stu')

  describe OdkSfLegacy::OdkToSalesforce::SubmissionProcessor do
    let(:mapping_id) { OdkSfLegacy::Mapping.first.id }
    let(:submission_id) { OdkSfLegacy::Submission.first.id }
    subject { described_class.new.perform(mapping_id,submission_id) }

    it "creates a object on Salesforce" do
      VCR.use_cassette("new_nested_repeats", record: :once) do
        subject
      end
    end
    
  end
end
