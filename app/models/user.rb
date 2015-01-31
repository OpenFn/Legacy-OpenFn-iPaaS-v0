class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :synced

  has_many :mappings, dependent: :destroy, class_name: "OdkSfLegacy::Mapping"

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :email, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :organisation, presence: true
  validates :role, inclusion: { in: %w(client admin), message: "%{value} is not a valid role" }

  before_validation :set_default_role, on: :create

  def admin?
    self.role == 'admin'
  end

  def has_available_mapping_credits?
    MappingLimiter.new(self).credits_available?
  end

  private
  def set_default_role
    self.role ||= 'client'
  end
end
