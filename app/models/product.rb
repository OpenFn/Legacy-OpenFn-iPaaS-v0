class Product < ActiveRecord::Base
  validates :name, presence: true

  scope :enabled, -> { where(enabled: true ) }

  def self.from_salesforce(salesforce_product)
    product = where(salesforce_id: salesforce_product.id).first_or_initialize
    
    product.name = salesforce_product.name
    product.description = salesforce_product.description
    product.website = salesforce_product.website
    product.enabled = salesforce_product.enabled

    return product
  end
end
