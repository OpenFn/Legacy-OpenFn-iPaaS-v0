require 'rails_helper'

RSpec.describe AvailableConnectionProfiles, type: :model do
  before :each do
    @product1 = Product.create(name: 'ODK1', description: "Open Data Kit (ODK)", integrated: true)
    @product2 = Product.create(name: 'SalesForce', description: "SalesForce", integrated: true)
    @source_profile = ConnectionProfile.create(name: 'ODK', type: 'source', product: @product1, user_id: 123, credential_id: 123)
    @destination_profile = ConnectionProfile.create(name: 'SalesForce1', type: 'destination', product: @product2, user_id: 123,
                                                   credential_id: 123)
  end

  describe '.for' do
    describe 'finds all available source connections' do
      before :each do
        @connections = described_class.for(:source, 123)
      end

      it "returns profiles" do
        expect(@connections[:connection_profiles].first).to eq @source_profile
      end

      it 'returns products' do
        expect(@connections[:products].first[:id]).to eq @product1.id
        expect(@connections[:products].first[:name]).to eq @product1.name
        expect(@connections[:products].first[:product]).to eq @product1.name
        expect(@connections[:products].first[:credential_type]).to eq "OdkCredential"
      end
    end

    describe 'finds all available destination connections' do
      before :each do
        @connections = described_class.for(:destination, 123)
      end

      it "returns profiles" do
        expect(@connections[:connection_profiles].first).to eq @destination_profile
      end

      it 'returns products' do
        expect(@connections[:products].last[:id]).to eq @product2.id
        expect(@connections[:products].last[:name]).to eq @product2.name
        expect(@connections[:products].last[:product]).to eq @product2.name
        expect(@connections[:products].last[:credential_type]).to eq "SalesforceCredential"
      end
    end
  end
end
