namespace :importer do
  task :periodic => :environment do
    OdkSfLegacy::Mapping.where(active: true, enabled: true).each do |mapping|
      Sidekiq::Client.enqueue OdkSfLegacy::OdkToSalesforce::Dispatcher, mapping.id, 50
    end
  end
end
