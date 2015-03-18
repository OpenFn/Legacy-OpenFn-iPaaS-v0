require 'openfn_odk/openfn_odk'

class OdkCredential < Credential
  store_accessor :details, :username
  store_accessor :details, :password
  store_accessor :details, :url

  validates_presence_of :username, :password, :url
  validate :verify_with_server, if: -> { should_verify_details? }

  def verify_with_server
    errors.add(:details, "Invalid credentials.") unless OpenFn::Odk.verify(self)
  end

  private

  def should_verify_details?
    self.new_record? || self.details_changed?
  end
end