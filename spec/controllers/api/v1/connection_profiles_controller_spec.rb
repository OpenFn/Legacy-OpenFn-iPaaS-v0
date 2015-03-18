require 'rails_helper'

RSpec.describe Api::V1::ConnectionProfilesController, :type => :controller do

  let(:source_connection_profiles) {
    [
      {
        id: 1,
        name: "ODKSource1",
        product: "odk"
      },
      {
        id: nil,
        product: "odk"
      }
    ]
  }

  let(:destination_connection_profiles) {
    [
      {
        id: 3,
        name: "SalesForceDestination1",
        product: "salesforce"
      },
      {
        id: nil,
        product: "salesforce"
      }

    ]
  }

  before :each do
    expect(controller).to receive(:require_login).and_return(true)
  end

  describe "#index" do
    before :each do
      expect(controller).to receive(:current_user).and_return(double(User, id: 123))
    end

    it "returns a HTTP 200" do
      get :index
      expect(response.status).to eq 200
    end

    context "reurns all connection profiles based on type" do
      it "type: source" do
        expect(ConnectionProfile).to receive(:source).and_return(source_connection_profiles)
        get :index, type: 'source'

        #Sanity check
        results = JSON.parse(response.body)["connection_profiles"]
        expect(results.first["id"]).to eq 1
        expect(results.first["name"]).to eq "ODKSource1"
        expect(results.first["product"]).to eq "odk"
      end

      it "type: destination" do
        expect(ConnectionProfile).to receive(:destination).and_return(destination_connection_profiles)
        get :index, type: 'destination'

        #Sanity check
        results = JSON.parse(response.body)["connection_profiles"]
        expect(results.first["id"]).to eq 3
        expect(results.first["name"]).to eq "SalesForceDestination1"
        expect(results.first["product"]).to eq "salesforce"
      end
    end
  end


  describe '#create' do
    let(:user) { double(User, id: 123) }
    let(:product) { Product.create(name: 'ODK1', description: "Open Data Kit (ODK)", integrated: true) }
    let(:post_params) { { connection_profile: { name: "New Connection Profile",
      product_id: product.id, type: 'source', credential_id: 123 } } }

    before :each do
      expect(controller).to receive(:current_user).and_return(user)
    end

    context "successful request" do
      it "returns a HTTP 201" do
        post :create, post_params
        expect(response.status).to eq 201
      end

      it "creates a new connection profile" do
        expect {
          post :create, post_params
        }.to change(ConnectionProfile, :count).by(1)
      end
    end

    context "failure" do
      it "returns a HTTP 400" do
        post :create, connection_profile: { name: '', product_id: '', type: ''}
        expect(response.status).to eq 400
      end
    end
  end

end