require 'rails_helper'

RSpec.describe Submission::PayloadDecoding, :type => :model do

  class OpenFn::TestProduct
    def self.decode(destination_payload)
    end
  end

  let(:record) { double(Submission::Record, { 
    id: 10,
    destination_payload: "{destination: 'payload'}",
    mapping: mapping
  }) }

  let(:mapping) { double(Mapping, {
    destination_app: double(ConnectedApp, product: product)
  }) }

  let(:product) { double(Product, integration_type: "TestProduct") }

  before(:each) do
    expect(Submission::Record).to receive(:find).with(10).and_return record
  end

  subject { Submission::PayloadDecoding.new.perform(record.id) }

  describe "responsibilities" do
    before(:each) do
      allow(Sidekiq::Client).to receive(:enqueue)
    end

    it "decodes the raw message according to the relevant Product Module" do
      allow(record).to receive(:raw_destination_payload=)
      allow(record).to receive(:save!)
      expect(OpenFn::TestProduct).to receive(:decode).with(record.destination_payload)

      subject
    end

    it "adds the decoded message to the record record" do
      expect(OpenFn::TestProduct).to receive(:decode).and_return(decoded_payload = "<raw><destination>payload</destination></raw>")
      expect(record).to receive(:raw_destination_payload=).with(decoded_payload)
      expect(record).to receive(:save!)

      subject
    end
  end

  
end
