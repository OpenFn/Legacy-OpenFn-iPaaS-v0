Restforce.configure do |config|
  config.security_token  = ENV['SALESFORCE_SECURITY_TOKEN']
  config.client_id       = ENV['SALESFORCE_KEY']
  config.client_secret   = ENV['SALESFORCE_SECRET']
  config.host            = ENV['SALESFORCE_URL'] if ENV['SALESFORCE_URL']
end
