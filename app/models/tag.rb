class Tag < ActiveRecord::Base

  has_many :taggings
  belongs_to :tag_category
  validates :name, presence: true, uniqueness: true
end
