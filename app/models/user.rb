class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :mappings, dependent: :destroy

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :email, uniqueness: true
end
