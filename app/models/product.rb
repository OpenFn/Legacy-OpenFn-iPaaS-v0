class Product < ActiveRecord::Base
  acts_as_taggable

  validates :name, presence: true

  scope :enabled, -> { where(enabled: true ) }

  def self.from_salesforce(salesforce_product)
    product = where(salesforce_id: salesforce_product.id).first_or_initialize
    
    product.name = salesforce_product.name
    product.description = salesforce_product.description
    product.website = salesforce_product.website
    product.enabled = salesforce_product.enabled
    product.integrated = salesforce_product.integrated
    product.tag_list = salesforce_product.tags

    return product
  end
end
