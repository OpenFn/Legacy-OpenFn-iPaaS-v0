class Product < ActiveRecord::Base

  acts_as_taggable

  has_many :votes
  has_many :reviews
  has_many :connection_profiles
  has_many :reviews

  validates :name, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :integrated, -> { where(integrated: true) }

  has_drafts

  def has_vote_for(user)
    votes.where(user: user).any?
  end

  def votes_count
    votes.count
  end

  def has_review_for(user)
    reviews.where(user: user).any?
  end

  def reviews_count
    reviews.count
  end

  def rating
    reviews.map(&:rating).inject(0, &:+).to_f / reviews_count
  end

end
