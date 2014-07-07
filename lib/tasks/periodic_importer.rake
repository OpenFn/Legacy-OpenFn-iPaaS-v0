namespace :importer do
  task :periodic => :environment do
    Mapping.where(active: true).each do |mapping|

      # kinda hacky, but nobody's watching
      user = {
        sf_username: ENV['SALESFORCE_USERNAME'],
        sf_password: ENV['SALESFORCE_PASSWORD'],
        sf_security_token: ENV['SALESFORCE_SECURITY_TOKEN']
      }

      Resque.enqueue OdkToSalesforce::Dispatcher, mapping.id, 50, user
    end
  end
end
