namespace :importer do
  task :periodic => :environment do
    OdkSfLegacy::Mapping.where(active: true, enabled: true, slow: false).each do |mapping|
      if mapping.user.plan.job_limit > mapping.user.legacy_count || mapping.user.unlimited
        Sidekiq::Client.enqueue OdkSfLegacy::OdkToSalesforce::Dispatcher, mapping.id, 50
      end
    end
  end
  task :slow => :environment do
    OdkSfLegacy::Mapping.where(active: true, enabled: true, slow: true).each do |mapping|
      if mapping.user.plan.job_limit > mapping.user.legacy_count || mapping.user.unlimited
        Sidekiq::Client.enqueue OdkSfLegacy::OdkToSalesforce::Dispatcher, mapping.id, 50
      end
    end
  end
end
