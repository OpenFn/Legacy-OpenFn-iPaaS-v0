class AvailableConnectionProfiles
  class << self

    def for(connection_profile_type, user_id)
      connection_profiles = ConnectionProfile.send(connection_profile_type, user_id)
      integrated_products = Product.integrated

      profiles = { connection_profiles: connection_profiles }

      profiles[:products] = integrated_products.inject([]) do |arr, item|
        arr << {
          id: item.id,
          name: item.name,
          product: item.name,
          credential_type: item.name =~ /odk/i ? "OdkCredential" : "SalesforceCredential",
        }
      end

      profiles
    end

  end
end