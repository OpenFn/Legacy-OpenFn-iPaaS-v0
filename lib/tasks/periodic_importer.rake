namespace :importer do
  task :periodic => :environment do
    Mapping.where(active: true).each do |mapping|
      Resque.enqueue OdkToSalesforce::Dispatcher, mapping.id, 75
    end
  end
end