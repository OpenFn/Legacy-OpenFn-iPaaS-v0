require 'rails_helper'

RSpec.describe UserObserver, :type => :model do
  let(:user) { double(::User, synced: false) }

  it "syncs the user to Salesforce" do
    #TODO This is about all the test can do until the restriction to production environment (in prod code) is lifted
    observer = UserObserver.instance

    expect(Salesforce::Listing::UserListing).to receive(:new).with(user).and_return(listing = double(Salesforce::Listing::User))

    observer.after_save(user)
  end

end
