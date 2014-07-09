Restforce.configure do |config|
# config.username        = ENV['SALESFORCE_USERNAME']
# config.password        = ENV['SALESFORCE_PASSWORD']
  config.security_token  = ENV['SALESFORCE_SECURITY_TOKEN']
  config.client_id       = ENV['SALESFORCE_KEY']
  config.client_secret   = ENV['SALESFORCE_SECRET']
  #config.host            = "salesforce.com"
end
