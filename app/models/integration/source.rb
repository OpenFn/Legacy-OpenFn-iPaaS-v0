class Integration::Source < ActiceRecord::Base
  belongs_to :product
  has_one :integration, inverse_of: :source
  has_one :api_key
  has_one :credential
end