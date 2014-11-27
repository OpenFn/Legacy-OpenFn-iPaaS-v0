class Integration::Destination < ActiceRecord::Base
  belongs_to :product
  has_one :integration, inverse_of: :destination
  has_one :credential
end