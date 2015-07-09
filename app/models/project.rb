class Project < ActiveRecord::Base
  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations
  belongs_to :organization
end
