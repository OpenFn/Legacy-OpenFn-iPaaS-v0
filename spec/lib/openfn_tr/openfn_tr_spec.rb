require 'spec_helper'
require 'openfn_tr/openfn_tr'

describe OpenFn::Tr do

  describe ".encode" do

    let(:raw_source_payload) {
      POST /incoming_message.php HTTP/1.1
      Host: yourserver.example.com
      Content-Type: application/x-www-form-urlencoded
      ...

      "event=incoming_message&from_number=%2B16505550123&content=Hello+world..."
    }

    subject { OpenFn::Odk.encode(raw_source_payload) }

    it "returns a generic data structure for OpenFn" do
      expect(subject).to eql raw_source_payload["data"]["event_cars_boats"]
    end
  end

  describe ".decode" do

  end

  describe ".verify" do
    before :each do
      @odk_connection = double
      @credential = OdkCredential.new(details: { username: 'ABC', password: '123', url: 'http://example.net' }, verified: nil)
      expect(OdkAggregate::Connection).to receive(:new).and_return(@odk_connection)
    end

    it 'verifies the credential object and returns true if valid' do
      expect(@odk_connection).to receive(:all_forms).and_return(true)
      expect(described_class.verify(@credential)).to eq true
    end

    it 'verifies the credential object and returns false if invalid' do
      expect(@odk_connection).to receive(:all_forms).and_raise("Nope")
      expect(described_class.verify(@credential)).to eq false
    end
  end
end
