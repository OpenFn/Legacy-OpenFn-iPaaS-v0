class UserObserver < ActiveRecord::Observer
  observe :user

  def after_save(user)
    listing = Salesforce::Listing::UserListing.new(user)
    Salesforce::Listing.sync!(listing)
  end
end