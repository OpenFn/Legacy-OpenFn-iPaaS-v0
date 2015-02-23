class Project < ActiveRecord::Base
  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations
  has_many :mappings, dependent: :destroy
  belongs_to :organization
end
