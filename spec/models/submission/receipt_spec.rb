require 'rails_helper'

RSpec.describe Submission::Receipt, :type => :model do

  let(:message) { "<an> <xml> string </xml> </an>" }
  let(:integration) { double(Integration) }

  before(:each) do
    @receipt = Submission::Receipt.new(message, integration)
  end

  describe "responsibilities" do
    before(:each) do
      expect(Resque).to receive(:enqueue).and_return(nil)
    end

    it "creates a submission record" do
      expect(Submission::Record).to receive(:create!).with(raw_source_message: message, integration: integration)
      @receipt.work
    end
  end

  describe "pipeline" do
    before(:each) do
      expect(Submission::Record).to receive(:create!).and_return(@submission = double)
    end

    it "enqueues PayloadEncoding" do
      expect(Submission::PayloadEncoding).to receive(:new).with(@submission).and_return(step = double)
      expect(Resque).to receive(:enqueue).with(step)

      @receipt.work
    end
  end
  
end
