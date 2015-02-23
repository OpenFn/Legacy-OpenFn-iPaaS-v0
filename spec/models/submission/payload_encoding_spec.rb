require 'rails_helper'

RSpec.describe Submission::PayloadEncoding, :type => :model do

  class OpenFn::TestProduct
    def self.encode(raw_source_payload)
    end
  end

  let(:record) { 
    double(Submission::Record, 
      raw_source_payload: "<raw><source>payload</source></raw>", 
      mapping: mapping,
      id: 10
    )
  }

  let(:mapping) { 
    double(Mapping, source_app: double({integration_type: "TestProduct"})) 
  }

  subject { Submission::PayloadEncoding.new.perform(record.id) }

  describe "responsibilities" do
    before :each do
      expect(Submission::Record).to receive(:find).with(10).and_return record
      allow(Sidekiq::Client).to receive(:enqueue)
    end

    it "decodes the raw message according to the relevant Product Module" do
      allow(record).to receive(:source_payload=)
      allow(record).to receive(:save!)
      expect(OpenFn::TestProduct).to receive(:encode).with(record.raw_source_payload)

      subject
    end

    it "adds the decoded message to the record record" do
      expect(OpenFn::TestProduct).to receive(:encode).and_return(decoded_payload = "{raw: {source: 'payload'}}")
      expect(record).to receive(:source_payload=).with(decoded_payload)
      expect(record).to receive(:save!)

      subject
    end
  end

end
