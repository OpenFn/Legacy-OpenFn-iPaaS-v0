require 'rails_helper'

RSpec.describe Submission::PayloadDecoding, :type => :model do

  let(:submission) { double(Submission, destination_payload: "{destination: 'payload'}", integration: integration) }
  let(:integration) { double(Integration, destination: destination) }
  let(:destination) { double(Integration::Destination, integration_type: 'TestProduct') }

  before(:each) do
    @decoding = Submission::PayloadDecoding.new(submission)
  end

  describe "responsibilities" do
    before(:each) do
      allow(Resque).to receive(:enqueue)
    end

    it "decodes the raw message according to the relevant Product Module" do
      allow(submission).to receive(:raw_destination_payload=)
      allow(submission).to receive(:save!)
      expect(Integration::TestProduct).to receive(:decode).with(submission.destination_payload)

      @decoding.work
    end

    it "adds the decoded message to the submission record" do
      expect(Integration::TestProduct).to receive(:decode).and_return(decoded_payload = "<raw><destination>payload</destination></raw>")
      expect(submission).to receive(:raw_destination_payload=).with(decoded_payload)
      expect(submission).to receive(:save!)

      @decoding.work
    end
  end

  describe "pipeline" do
    before(:each) do
      allow(Integration::TestProduct).to receive(:decode)
      allow(submission).to receive(:raw_destination_payload=)
      allow(submission).to receive(:save!)
    end

    it "enqueues Dispatch" do
      expect(Submission::Dispatch).to receive(:new).with(submission).and_return(step = double)
      expect(Resque).to receive(:enqueue).with(step)

      @decoding.work
    end
  end
  
end