class Review < ActiveRecord::Base

  belongs_to :user
	belongs_to :product
  has_many :review_votes

  validates :user_id, :presence => true
  validates :product_id, :presence => true
  validates :review, :presence => true
  validates :rating, :presence => true
  validates :user_id, :uniqueness => {:scope => [:product_id]}

  def self.calculate_product_rating(params)
    # currently working on this method
  end

end



