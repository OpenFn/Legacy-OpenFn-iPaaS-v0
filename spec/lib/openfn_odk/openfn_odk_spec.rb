require 'spec_helper'
require 'openfn_odk/openfn_odk'

describe OpenFn::Odk do

  describe ".encode" do

    let(:raw_source_payload) {
      {"xmlns"=>"http://opendatakit.org/submissions",
       "xmlns:orx"=>"http://openrosa.org/xforms",
       "data"=>
       {"event_cars_boats"=>
        {"id"=>"Events_Boats_Cars",
         "instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084",
         "submissionDate"=>"2014-11-11T08:04:40.178Z",
         "isComplete"=>"true",
         "markedAsCompleteDate"=>"2014-11-11T08:04:40.178Z",
         "event_name"=>"Catalina wine mixer",
         "start_date"=>"2014-11-11",
         "boats"=>[{"boat_name"=>"Big boat"}, {"boat_name"=>"Catamaran"}, {"boat_name"=>"Catatafish"}],
         "cars"=>{"car_name"=>"Peugeot"},
         "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"}}}}
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
