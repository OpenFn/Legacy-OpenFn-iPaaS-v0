require 'rails_helper'

RSpec.describe OdkSfLegacy::OdkToSalesforce::SubmissionProcessor, type: :model do

  # User
  # ODK Fields
  # Salesforce Fields
  # Mapping
  #
  # Submission
  #


  fixtures :mappings
  fixtures :users
  fixtures :salesforce_objects
  fixtures :salesforce_fields
  fixtures :salesforce_relationships
  fixtures :odk_fields
  fixtures :odk_field_salesforce_fields

  let(:submission_processor) { OdkSfLegacy::OdkToSalesforce::SubmissionProcessor.new(60, 49) }

  subject { submission_processor.perform }

  it "should do some shit" do
    VCR.use_cassette :event_boats_cars do
      subject
    end
  end

end
