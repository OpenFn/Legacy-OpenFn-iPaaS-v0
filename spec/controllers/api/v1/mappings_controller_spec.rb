require 'rails_helper'

RSpec.describe Api::V1::MappingsController, :type => :controller do
	before :each do
		@mapping = double(Mapping, name: 'Salesforce')
		@user = double(User, id: 123)
		expect(Mapping).to receive(:where).and_return [@mapping]
    expect(controller).to receive(:require_login).and_return(true)
    expect(controller).to receive(:current_user).and_return(@user)
	end

	describe "#show" do
		it 'returns a HTTP 200' do
			get :show, id: 1
			expect(response.status).to eq 200
		end

		it 'returns a Mapping' do
			get :show, id: 1
			puts response.body.inspect
			mapping = JSON.parse(response.body)
			expect(mapping['name']).to eq 200
		end
	end

	describe '#create' do

	end

	describe '#update' do
	end
end
