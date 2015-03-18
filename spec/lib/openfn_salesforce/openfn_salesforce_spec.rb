require 'spec_helper'
require 'openfn_salesforce/openfn_salesforce'

describe OpenFn::Salesforce do
	describe '.verify' do
    before :each do
      @sf_connection = double
      @credential = SalesforceCredential.new(details: { key: 1, another_key: 2 }, verified: nil)
      expect(Restforce).to receive(:new).and_return(@sf_connection)
    end

    it 'verifies the credential object and returns true if valid' do
      expect(@sf_connection).to receive(:describe).and_return(true)
      expect(described_class.verify(@credential)).to eq true
    end

    it 'verifies the credential object and returns false if invalid' do
      expect(@sf_connection).to receive(:describe).and_raise("Nope")
      expect(described_class.verify(@credential)).to eq false
    end
  end
end
