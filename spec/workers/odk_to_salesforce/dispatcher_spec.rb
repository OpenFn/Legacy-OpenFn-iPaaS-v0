require "rails_helper"

module OdkSfLegacy
  RSpec.describe OdkToSalesforce::Dispatcher do
    let(:data) { "good stuff"}
    let(:import) { double(Import, submissions: submissions_collection) }
    let(:limit) { 10 }
    let(:mapping) { double(Mapping, create_import: import, import: nil, odk_form: odk_form, user: user, id: 451) }
    let(:media_data) { [{}, {}]}
    let(:odk) { double(OdkToSalesforce::Odk, submissions: []) }
    let(:odk_form) { double(OdkForm, name: "Form_Blah")}
    let(:submission) { double(Submission, id: 123) }
    let(:submission_hash) { {"data" => {"lots of" => data}, "mediaFile" => media_data} }
    let(:submissions_collection) { double }
    let(:user) { double(User) }
    let(:uuid) { "uuid:123" }
    subject { described_class.new }

    before(:each) do
      allow(Mapping).to receive(:find).and_return(mapping)
      allow(OdkToSalesforce::Odk).to receive(:new).and_return(odk)
    end

    describe "enqueueing the submissions" do
      it "creates an import instance for the mapping" do
        expect(mapping).to receive(:create_import).with(odk_formid: odk_form.name)

        subject.perform(mapping.id, limit)
      end

      it "does not create an import if there is already one associated with the mapping" do
        allow(mapping).to receive(:import).and_return(import)
        expect(mapping).to_not receive(:create_import)

        subject.perform(mapping.id, limit)
      end

      it "creates an ODK connection" do
        expect(OdkToSalesforce::Odk).to receive(:new).with(odk_form.name, import, limit, user).and_return(odk)

        subject.perform(mapping.id, limit)
      end

      it "creates a submission DB entry for each ODK submission" do
        pending("This is because fixtures are missing. TODO, ask Stu and Rory.")
        allow(odk).to receive(:submissions).and_return([uuid])
        expect(odk).to receive(:fetch_submission).with(uuid).and_return(submission_hash)
        expect(submissions_collection).to receive(:create).with(uuid: uuid, data: data, media_data: media_data).and_return(submission)

        subject.perform(mapping.id, limit)
      end

      it "adds an entry to the queue for import to Salesforce" do
        allow(odk).to receive(:submissions).and_return([uuid])
        allow(odk).to receive(:fetch_submission).and_return(submission_hash)
        allow(submissions_collection).to receive(:create).and_return(submission)
        expect(Sidekiq::Client).to receive(:enqueue).with(OdkToSalesforce::SubmissionProcessor, mapping.id, submission.id)

        subject.perform(mapping.id, limit)
      end
    end
  end
end
