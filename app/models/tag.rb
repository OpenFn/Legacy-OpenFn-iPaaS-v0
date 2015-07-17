class Tag < ActiveRecord::Base

  has_many :taggings, :dependent => :destroy
  belongs_to :tag_category
  validates :name, presence: true, uniqueness: true
end
