class ReviewVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :review

  validates_uniqueness_of :user_id, :scope => :review_id
end
