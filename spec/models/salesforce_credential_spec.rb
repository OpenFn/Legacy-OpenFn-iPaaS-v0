require 'rails_helper'

RSpec.describe SalesforceCredential, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:host) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:security_token) }
    it { should validate_presence_of(:app_key) }
    it { should validate_presence_of(:app_secret) }

    it '#verify_with_server - adds an error to the credential model when credentials are invalid' do
			sf_credentials = { username: 'ABC', password: '123', security_token: 'TOKEN_ABC_123',
        app_key: 'CLIENT_ABC_123', app_secret: 'CLIENT_SECRET_ABC_123', host: 'http://example.net' }

			expect(OpenFn::Salesforce).to receive(:verify).and_return(false)
      credential = SalesforceCredential.create(details: sf_credentials, verified: Date.today)

      expect(credential.errors.messages[:details]).to eq ["Invalid credentials."]
    end
  end
end