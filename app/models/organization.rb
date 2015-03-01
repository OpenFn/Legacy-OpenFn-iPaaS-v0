class Organization < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  belongs_to :plan

  validates :name, presence: true
end
