require 'rails_helper'

RSpec.describe Credential, :type => :model do

  it { should have_many(:users) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:details) }

  let(:sf_credentials) { { username: 'ABC', password: '123', security_token: 'TOKEN_ABC_123',
                            app_key: 'CLIENT_ABC_123', app_secret: 'CLIENT_SECRET_ABC_123',
                            host: 'http://example.net'
  } }

  let(:odk_credentials) { { username: 'ABC', password: '123', url: 'http://example.net' } }

  describe 'Scopes' do
  	it '#odk returns all credentials of ODK type' do
      odk_credential = OdkCredential.new(details: odk_credentials, verified: Date.today)
      expect(odk_credential).to receive(:verify_with_server).and_return true
      odk_credential.save!

  		expect(Credential.odk).to eq [odk_credential]
  	end

  	it '#salesforce returns all credentials of Salesforce type' do
  		sf_credential = SalesforceCredential.new(details: sf_credentials, verified: Date.today)
      expect(sf_credential).to receive(:verify_with_server).and_return true
      sf_credential.save!

  		expect(Credential.salesforce).to eq [sf_credential]
  	end
  end

  describe "#is_valid?" do
    it 'returns true if verified != nil' do
      credential = Credential.new(details: { key: 'ABC123'}, verified: Date.today)
      expect(credential.is_valid?).to eq true
    end

    it 'returns false if verified == nil' do
      credential = Credential.new(details: { key: 'ABC123'}, verified: nil)
      expect(credential.is_valid?).to eq false
    end
  end

  describe '#verify' do
    it "sets 'verified' to today's date" do
      credential = SalesforceCredential.new(details: sf_credentials, verified: nil)
      credential.verify
      expect(credential.verified).to eq Date.today
    end
  end

end
