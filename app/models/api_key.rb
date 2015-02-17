class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  belongs_to :connected_app
  validates :role, inclusion: { in: %w(admin integration) }

  def admin?
    self.role == 'admin'
  end

  private
  def generate_access_token
    self.access_token = SecureRandom.hex
  end
end
