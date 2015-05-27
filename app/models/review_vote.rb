class ReviewVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :review

  validates :user_id, :uniqueness => {:scope => [:review_id, :value]}
end
