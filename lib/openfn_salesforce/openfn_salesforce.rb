class OpenFn::Salesforce
  class << self

    def verify credential
      connection = Restforce.new({
        username: credential.username,
        password: credential.password,
        security_token: credential.security_token,
        client_id: credential.app_key,
        client_secret: credential.app_secret,
        host: credential.host
        })

      begin
        connection.describe
        return true
      rescue => e
        Rails.logger.info "Salesforce Credential check failed with:\n#{e.backtrace.join("\n")}"
        return false
      end
    end

  end
end