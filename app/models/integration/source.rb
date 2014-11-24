#designsketch

class Integration::Source < ActiveRecord::Base
  belongs_to :product
  has_one :integration, inverse_of: :source
  belongs_to :api_key
  belongs_to :credential

  def integration_type
    product.integration_type
  end
end