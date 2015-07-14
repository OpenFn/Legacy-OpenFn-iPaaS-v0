require 'spec_helper'
require 'openfn_commcare/openfn_commcare'

describe OpenFn::CommCare do

  describe ".encode" do

    let(:raw_source_payload) {
    "meta": {
        "limit": 20,
        "next": "/a/corpora/api/v0.5/form/?limit=20&offset=20",
        "offset": 0,
        "previous": null,
        "total_count": 6909
    },
    "objects": [
        {
            "app_id": "572e968957920fc3e92578988866a5e8",
            "archived": false,
            "build_id": "78698f1516e7d16689e05fce852d1e9c",
            "form": {
                "#type": "data",
                "@name": "Case Update",
                "@uiVersion": "1",
                "@version": "186",
                "@xmlns": "http://openrosa.org/formdesigner/4B1B717C-0CF7-472E-8CC1-1CC0C45AA5E0",
                "case": {
                    "@case_id": "8f8fd909-684f-402d-a892-f50e607fffef",
                    "@date_modified": "2012-09-29T19:10:00",
                    "@user_id": "f4c63df2ef7f9da2f93cab12dc9ef53c",
                    "@xmlns": "http://commcarehq.org/case/transaction/v2",
                    "update": {
                        "data_node": "55",
                        "dateval": "2012-09-26",
                        "geodata": "5.0 5.0 5.0 5.0",
                        "intval": "5",
                        "multiselect": "b",
                        "singleselect": "b",
                        "text": "TEST"
                    }
                },
                "data_node": "55",
                "geodata": "5.0 5.0 5.0 5.0",
                "meta": {
                    "@xmlns": "http://openrosa.org/jr/xforms",
                    "appVersion": {
                        "#text": "v2.1.0dev (1d8fba-0884f9-unvers-2.1.0-Nokia/S40-generic) build 186 App #186 b:2012-Sep-27 r:2012-Sep-28",
                        "@xmlns": "http://commcarehq.org/xforms"
                    },
                    "deviceID": "0LRGVM4SFN2VHCOVWOVC07KQX",
                    "instanceID": "00460026-a33b-4c6b-a4b6-c47117048557",
                    "timeEnd": "2012-09-29T19:10:00",
                    "timeStart": "2012-09-29T19:08:46",
                    "userID": "f4c63df2ef7f9da2f93cab12dc9ef53c",
                    "username": "afrisis"
                },
                "old_data_node": "",
                "question1": "OK",
                "question11": "5",
                "question12": "2012-09-26",
                "question14": "OK",
                "question3": "b",
                "question7": "b",
                "text": "TEST"
            },
            "id": "00460026-a33b-4c6b-a4b6-c47117048557",
            "md5": "OBSOLETED",
            "metadata": {
                "@xmlns": "http://openrosa.org/jr/xforms",
                "appVersion": "@xmlns:http://commcarehq.org/xforms, #text:v2.1.0dev (1d8fba-0884f9-unvers-2.1.0-Nokia/S40-generic) build 186 App #186 b:2012-Sep-27 r:2012-Sep-28",
                "deprecatedID": null,
                "deviceID": "0LRGVM4SFN2VHCOVWOVC07KQX",
                "instanceID": "00460026-a33b-4c6b-a4b6-c47117048557",
                "timeEnd": "2012-09-29T19:10:00",
                "timeStart": "2012-09-29T19:08:46",
                "userID": "f4c63df2ef7f9da2f93cab12dc9ef53c",
                "username": "afrisis"
            },
            "received_on": "2012-09-29T17:24:52",
            "resource_uri": "",
            "type": "data",
            "uiversion": "1",
            "version": "186"
        }
    ]
}

    subject { OpenFn::CommCare.encode(raw_source_payload) }

    it "returns a generic data structure for OpenFn" do
      pending("TODO")
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
      pending("TODO")
      expect(@odk_connection).to receive(:all_forms).and_return(true)
      expect(described_class.verify(@credential)).to eq true
    end

    it 'verifies the credential object and returns false if invalid' do
      pending("TODO")
      expect(@odk_connection).to receive(:all_forms).and_raise("Nope")
      expect(described_class.verify(@credential)).to eq false
    end
  end
end
