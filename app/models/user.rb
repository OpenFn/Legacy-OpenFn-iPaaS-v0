class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :synced

  has_many :mappings, dependent: :destroy, class_name: "OdkSfLegacy::Mapping"
  has_many :collaborations, dependent: :destroy
  has_many :projects, through: :collaborations
  belongs_to :organization

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :email, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, inclusion: { in: %w(client client_admin admin), message: "%{value} is not a valid role" }

  accepts_nested_attributes_for :organization, allow_destroy: true

  before_validation :set_default_role, on: :create
  after_create :set_role

  def admin?
    self.role == 'admin'
  end

  def client_admin?
    role == 'client_admin'
  end

  def has_available_mapping_credits?
    MappingLimiter.new(self).credits_available?
  end

  private
    def set_default_role
      self.role ||= 'client'
    end

    def set_role
      self.update(role: 'client_admin') if organization.present?
    end
end
