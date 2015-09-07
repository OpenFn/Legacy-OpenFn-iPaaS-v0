class UserObserver < ActiveRecord::Observer
  observe :user

  # def after_save(user)
    # do not send updates back to salesforce forever
    # return if user.synced

    # listing = Salesforce::Listing::UserListing.new(user)
    # if Rails.env.production? && Features.sync_with_salesforce?
      # Salesforce::Listing.sync!(listing)  
    # end
  # end
end