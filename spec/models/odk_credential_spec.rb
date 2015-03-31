require 'rails_helper'

RSpec.describe OdkCredential, type: :model do

  describe "Validations" do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:url) }

    it '#verify_with_server - adds an error to the credential model when credentials are invalid' do
  		odk_credentials =  { username: 'ABC', password: '123', url: 'http://example.net' }
      expect(OpenFn::Odk).to receive(:verify).and_return(false)
      credential = OdkCredential.create(details: odk_credentials, verified: Date.today)

      expect(credential.errors.messages[:details]).to eq ["Invalid credentials."]
    end
  end
end