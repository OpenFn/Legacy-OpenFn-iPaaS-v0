class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :logo_path, presence: true
  validates :inactive_logo_path, presence: true, if: -> (prod) { !prod.active_source || !prod.active_destination }

  def self.from_salesforce(salesforce_product)
    product = where(salesforce_id: salesforce_product.id).first_or_initialize
    
    product.name = salesforce_product.name
    product.description = salesforce_product.description
    product.website = salesforce_product.website

    return product
  end
end
