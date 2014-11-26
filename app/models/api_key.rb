class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  def admin?
    self.role == 'admin'
  end

  private
  def generate_access_token
    self.access_token = SecureRandom.hex
  end
end