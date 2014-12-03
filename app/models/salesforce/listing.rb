class Salesforce::Listing

  def self.sync!(listing)
    Salesforce.admin_connection.upsert!(listing.salesforce_object_name, listing.salesforce_upsert_key, listing.salesforce_attributes)
  end
  
end
