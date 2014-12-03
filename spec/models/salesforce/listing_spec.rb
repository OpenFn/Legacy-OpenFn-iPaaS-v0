# require 'rails_helper'

# RSpec.describe Salesforce::Listing, :type => :model do

#   let(:listing) {
#     double(Salesforce::Listing::UserListing, 
#       salesforce_object_name: 'Salesforce_Object',
#       salesforce_attributes: {salesforce: 'attrtibute'})
#   }

#   it "syncs a listing to salesforce" do
#     expect(Salesforce).to receive(:admin_connection).and_return(connection = double(Restforce))
#     expect(connection).to receive(:upsert!).with('Salesforce_Object', {salesforce: 'attrtibute'})

#     Salesforce::Listing.sync!(listing)
#   end
  
# end