require 'rails_helper'

RSpec.describe Submission::Translation, :type => :model do

  let(:submission) { double(Submission, source_payload: "{raw: {source: 'payload'}}", integration: integration) }
  let(:integration) { double(Integration, mappings: mappings) }
  let(:mappings) { [ double(Mapping::Definition) ] }
  let(:translation) { double(Mapping::Translation, result: "{destination: 'payload'}") }

  before(:each) do
    @encoding = Submission::Translation.new(submission)
  end

  describe "responsibilities" do
    before(:each) do
      allow(Resque).to receive(:enqueue)
    end

    it "translates the source payload according to the specified mappings" do
      allow(submission).to receive(:destination_payload=)
      allow(submission).to receive(:save!)
      expect(Mapping::Translation).to receive(:new).with(submission.source_payload, mappings).and_return(translation)

      @encoding.work
    end

    it "adds the decoded message to the submission record" do
      allow(Mapping::Translation).to receive(:new).and_return(translation)
      expect(submission).to receive(:destination_payload=).with(translation.result)
      expect(submission).to receive(:save!)

      @encoding.work
    end
  end

  describe "pipeline" do
    before(:each) do
      allow(Mapping::Translation).to receive(:new).and_return(translation)
      allow(submission).to receive(:destination_payload=)
      allow(submission).to receive(:save!)
    end

    it "enqueues Dispatch" do
      expect(Submission::PayloadDecoding).to receive(:new).with(submission).and_return(step = double)
      expect(Resque).to receive(:enqueue).with(step)

      @encoding.work
    end
  end
end
