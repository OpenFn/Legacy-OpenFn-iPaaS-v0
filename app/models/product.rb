class Product < ActiveRecord::Base
  acts_as_taggable

  has_many :votes
  has_many :reviews
  has_many :connection_profiles
  has_many :reviews

  validates :name, presence: true

  scope :enabled, -> { where(enabled: true) }
  scope :integrated, -> { where(integrated: true) }

  def self.from_salesforce(salesforce_product)
    product = where(salesforce_id: salesforce_product.id).first_or_initialize

    product.name = salesforce_product.name
    product.description = salesforce_product.description
    product.website = salesforce_product.website
    product.enabled = salesforce_product.enabled
    product.integrated = salesforce_product.integrated
    product.tag_list = salesforce_product.tags
    product.costs = salesforce_product.costs
    product.reviews = salesforce_product.reviews
    product.resources = salesforce_product.resources
    product.provider = salesforce_product.provider
    product.detailed_description = salesforce_product.detailed_description
    product.update_link = salesforce_product.update_link
    product.detail_active = salesforce_product.detail_active
    product.tech_specs = salesforce_product.tech_specs
    product.sf_link = salesforce_product.sf_link
    product.twitter = salesforce_product.twitter
    product.facebook = salesforce_product.facebook
    product.email = salesforce_product.email

    return product
  end

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

end
