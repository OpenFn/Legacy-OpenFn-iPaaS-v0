# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Plan.count < 1
  plans = Plan.create(
    [{ name: 'Free', price: 0, project_limit: 1, user_limit: 1, connected_app_limit: 2, map_limit: 1, support_type: 'Limited', job_limit: 100, sync_interval: 'Auto' },
	 { name: 'Entry', price: 39, project_limit: 1, user_limit: 1, connected_app_limit: 2, map_limit: 3, support_type: 'Limited', job_limit: 1000, sync_interval: 'Auto'},
	 { name: 'Startup', price: 79, project_limit: 2, user_limit: 5, connected_app_limit: 10, map_limit: 10, support_type: 'Email', job_limit: 2000, sync_interval: 'Auto'},
	 { name: 'Growth', price: 299, project_limit: 5, user_limit: 20, connected_app_limit: 20, map_limit: 20, support_type: 'Live Chat', job_limit: 5000, sync_interval: 'Rapid'},
	 { name: 'Enterprise', price: 999, project_limit: 20, user_limit: 80, connected_app_limit: 2147483647, map_limit: 80, support_type: 'Limited', job_limit: 2147483647, sync_interval: 'Rapid'}
	]
  )
end

# TODO: create dummy products and get them loading properly.
if Product.count < 1
  products = Product.create(
    [{ name: 'Sample SMS Gateway',
    	description: 'This thing sends and receives SMSs in bulk.',
    	website: 'http://www.google.com',
    	enabled: true,
    	integrated: false,
    	detail_active: true,
    	costs: 'It is all very expensive and complicated.',
    	resources: 'Here is a list of external resources to help you understand or implement this product.',
    	provider: 'This cool company.',
    	detailed_description: 'A long long time ago, telephone companies decided to experiment with sending small packets of data over the airwaves, and charging arbitrary fees for each of these little packets.',
    	tech_specs: 'This is fairly technical.',
    	twitter: 'taylordowns2000', facebook: 'openfn'},
	]
  )
end