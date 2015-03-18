require 'rails_helper'

RSpec.describe ConnectionProfile, :type => :model do

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:product_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_inclusion_of(:type).in_array(['source', 'destination']) }
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe 'Scopes' do
    before :each do
      @user = double(User, id: 123)
      @odk = Product.create(name: 'ODK1', description: "Open Data Kit (ODK)", integrated: true)
      @sf = Product.create(name: 'ODK1', description: "Open Data Kit (ODK)", integrated: true)
      ConnectionProfile.create(name: 'ODKSource1', type: 'source', product: @odk, user_id: @user.id, credential_id: 123)
      ConnectionProfile.create(name: 'ODKSource2', type: 'source', product: @odk, user_id: @user.id, credential_id: 123)
      ConnectionProfile.create(name: 'SalesForce1', type: 'destination', product: @sf, user_id: @user.id, credential_id: 123)
    end

    describe '#source' do
      it 'returns ConnectionProfile(s) with type: source' do
        sources = ConnectionProfile.source(@user.id)
        expect(sources.length).to eq 2
        expect(sources.first.name).to eq 'ODKSource1'
        expect(sources.second.name).to eq 'ODKSource2'
      end
    end

    describe '#destination' do
      it 'returns ConnectionProfile(s) with type: destination' do
        destinations = ConnectionProfile.destination(@user.id)
        expect(destinations.length).to eq 1
        expect(destinations.first.name).to eq 'SalesForce1'
      end
    end
  end

end
