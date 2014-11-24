require 'rails_helper'

RSpec.describe Submission::PayloadEncoding, :type => :model do

  let(:submission) { double(Submission, raw_source_payload: "<raw><source>payload</source></raw>", integration: integration) }
  let(:integration) { double(Integration, source: source) }
  let(:source) { double(Integration::Source, integration_type: 'TestProduct') }

  before(:each) do
    @encoding = Submission::PayloadEncoding.new(submission)
  end

  describe "responsibilities" do
    before(:each) do
      allow(Resque).to receive(:enqueue)
    end

    it "decodes the raw message according to the relevant Product Module" do
      allow(submission).to receive(:source_payload=)
      allow(submission).to receive(:save!)
      expect(Integration::TestProduct).to receive(:encode).with(submission.raw_source_payload)

      @encoding.work
    end

    it "adds the decoded message to the submission record" do
      expect(Integration::TestProduct).to receive(:encode).and_return(decoded_payload = "{raw: {source: 'payload'}}")
      expect(submission).to receive(:source_payload=).with(decoded_payload)
      expect(submission).to receive(:save!)

      @encoding.work
    end
  end

  describe "pipeline" do
    before(:each) do
      allow(Integration::TestProduct).to receive(:encode)
      allow(submission).to receive(:source_payload=)
      allow(submission).to receive(:save!)
    end

    it "enqueues Dispatch" do
      expect(Submission::Translation).to receive(:new).with(submission).and_return(step = double)
      expect(Resque).to receive(:enqueue).with(step)

      @encoding.work
    end
  end
  
end
