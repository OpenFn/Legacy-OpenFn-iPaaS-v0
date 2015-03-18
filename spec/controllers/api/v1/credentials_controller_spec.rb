require 'rails_helper'

RSpec.describe Api::V1::CredentialsController, :type => :controller do
  before :each do
    expect(controller).to receive(:require_login).and_return(true)
  end

  describe 'POST #create' do

    context "ODK" do
      before :each do
        expect(OpenFn::Odk).to receive(:verify).and_return(true)
        post :create, credential: { username: 'jdoe', password: 'doe123',
          url: 'http://jdoe.com', type: :OdkCredential }
      end

      it 'returns a status 201' do
        expect(response.status).to eq 201
      end

      it 'returns a new credential object' do
        obj = JSON.parse(response.body)
        expect(obj["credential"]["details"]["username"]).to eq 'jdoe'
        expect(obj["credential"]["details"]["password"]).to eq 'doe123'
        expect(obj["credential"]["details"]["url"]).to eq 'http://jdoe.com'
      end
    end

    context 'Salesforce' do
      before :each do
        expect(OpenFn::Salesforce).to receive(:verify).and_return(true)
        post :create, credential: { username: 'jdoe', password: 'jane123',
          security_token: 'TOKEN_123', app_key: 'APP_123', app_secret: 'SECRET_123',
          host: 'http://sf.janedoe.com', type: :SalesforceCredential }
      end

      it 'returns a status 201' do
        expect(response.status).to eq 201
      end

      it 'returns a new credential object' do
        obj = JSON.parse(response.body)
        expect(obj['credential']['details']['username']).to eq 'jdoe'
        expect(obj['credential']['details']['password']).to eq 'jane123'
        expect(obj['credential']['details']['app_key']).to eq 'APP_123'
      end

    end

  end
end