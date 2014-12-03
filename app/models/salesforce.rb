class Salesforce
  def self.admin_connection
    Restforce.new({
      username: ENV["SF_ADMIN_EMAIL"],
      password: ENV["SF_ADMIN_PASSWORD"],
      security_token: ENV["SF_ADMIN_SECURITY_TOKEN"],
      client_id: ENV["SF_CONSUMER_KEY"],
      client_secret: ENV["SF_CONSUMER_SECRET"],
      host: ENV["SF_HOST"]
    })
  end
end