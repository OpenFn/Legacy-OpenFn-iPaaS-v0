class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  has_one :integration_source
  has_one :integration_destination
  validates :role, inclusion: { in: %w(admin integration) }

  def admin?
    self.role == 'admin'
  end

  # shouldn't need this, but here's how if necessary.
  # def integration 
  #   (integration_source || integration_destination).integration
  # end

  private
  def generate_access_token
    self.access_token = SecureRandom.hex
  end
end