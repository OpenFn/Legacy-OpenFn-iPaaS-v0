class Review < ActiveRecord::Base

  belongs_to :user
	belongs_to :product
  has_many :review_votes

  def self.calculate_product_rating(params)
    # currently working on this method
  end

end

#(sum of (review rating * (IF(review_vote_score>=0, max(review_vote_score, 1), 0) / sum of (IF(review_vote_score>=0, max(review_vote_score, 1))

