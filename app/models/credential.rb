class Credential < ActiveRecord::Base
  store_accessor :details

  has_many :users, through: :connection_profiles
  has_many :connection_profiles
  validates_presence_of :type, :details

  scope :odk, -> { where(type: 'OdkCredential') }
  scope :salesforce, -> { where(type: 'SalesforceCredential') }

  # credential details are stored in an hstore hash called details.

  def is_valid?
    !verified.nil?
  end

  def verify
    self.verified = Date.today
  end

  def verify!
    verify
    self.save!
  end
end
