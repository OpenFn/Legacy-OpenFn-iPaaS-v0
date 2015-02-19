require 'rails_helper'

module OdkSfLegacy
  RSpec.describe OdkToSalesforce::SubmissionProcessor, type: :model do

    # User
    # ODK Fields
    # Salesforce Fields
    # Mapping
    #
    # Submission
    #


    fixtures :odk_sf_legacy_mappings
    fixtures :odk_sf_legacy_submissions
    fixtures :users
    fixtures :odk_sf_legacy_salesforce_objects
    fixtures :odk_sf_legacy_salesforce_fields
    fixtures :legacy_salesforce_relationships
    fixtures :odk_sf_legacy_odk_fields
    fixtures :legacy_odk_field_salesforce_fields

    let(:submission_processor) { OdkSfLegacy::OdkToSalesforce::SubmissionProcessor.new(60, 49) }

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
end
