class Integration::Source < ActiceRecord::Base
  belongs_to :product
  has_one :integration, inverse_of: :source
  belongs_to :api_key
  belongs_to :credential
end