class Tag < ActiveRecord::Base

  has_many :taggings
  validates :name, presence: true, uniqueness: true

end
