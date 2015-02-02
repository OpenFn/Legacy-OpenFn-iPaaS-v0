namespace :importer do
  task :periodic => :environment do
    Mapping.where(active: true, enabled: true).each do |mapping|
      Sidekiq::Client.enqueue OdkToSalesforce::Dispatcher, mapping.id, 50
    end
  end
end
