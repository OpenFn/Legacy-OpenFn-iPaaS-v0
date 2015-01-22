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
  fixtures :submissions
  fixtures :users
  fixtures :salesforce_objects
  fixtures :salesforce_fields
  fixtures :salesforce_relationships
  fixtures :odk_fields
  fixtures :odk_field_salesforce_fields

  let(:submission_processor) { OdkSfLegacy::OdkToSalesforce::SubmissionProcessor.new(60, 49) }

  # subject { submission_processor.perform }

  it "should do some shit" do
    pending "This spec will soon be the home of...."
    VCR.use_cassette :event_boats_cars do
      subject
    end
  end

  describe "processing a submission" do
    let(:restforce_connection) { double.as_null_object }
    before(:each) do
      allow(RestforceService).to receive(:new).and_return(restforce_connection)
    end
    subject {}
    it "replaces filenames with a downloadURI for binary ODK fields" do
      processor = OdkToSalesforce::SubmissionProcessor.new

      processor.perform(61,53)

      processor.all_import_objects.last.attributes["Photo"].should eql "https://fake.url.for.image?blobKey=media_handling[@version=null and @uiVersion=null]/photohandling"
    end

    it "leaves the filename in a binary ODK field in place if it can't be mapped to media data" do
      processor = OdkToSalesforce::SubmissionProcessor.new

      processor.perform(61,54)

      processor.all_import_objects.last.attributes["Photo"].should eql "blah.jpg"
    end

    it "leaves the filename in a binary ODK field in place if the submission has no media data at all" do
      processor = OdkToSalesforce::SubmissionProcessor.new

      processor.perform(61,55)

      processor.all_import_objects.last.attributes["Photo"].should eql "blah.jpg"
    end
  end
end
