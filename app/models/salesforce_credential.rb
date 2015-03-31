require 'openfn_salesforce/openfn_salesforce'

class SalesforceCredential < Credential
  store_accessor :details, :username
  store_accessor :details, :password
  store_accessor :details, :security_token
  store_accessor :details, :app_key
  store_accessor :details, :app_secret
  store_accessor :details, :host

 validates_presence_of :username, :password, :security_token, :app_key, :app_secret, :host

  validate :verify_with_server, if: -> { should_verify_details? }

  def verify_with_server
    errors.add(:details, "Invalid credentials.") unless OpenFn::Salesforce.verify(self)
  end

  private

  def should_verify_details?
    self.new_record? || self.details_changed?
  end
end