class Integration::Destination < ActiveRecord::Base
  belongs_to :product
  has_one :integration, inverse_of: :destination
  belongs_to :credential

  def integration_type
    product.integration_type
  end
end