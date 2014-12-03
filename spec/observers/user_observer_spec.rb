require 'rails_helper'

RSpec.describe UserObserver, :type => :model do
  let(:user) { double(::User) }

  it "syncs the user to Salesforce" do 
    observer = UserObserver.instance

    expect(Salesforce::Listing::UserListing).to receive(:new).with(user).and_return(listing = double(Salesforce::Listing::User))
    expect(Salesforce::Listing).to receive(:sync!).with(listing)

    observer.after_save(user)
  end
  
end
