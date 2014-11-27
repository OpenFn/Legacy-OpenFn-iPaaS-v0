class Integration::Destination < ActiceRecord::Base
  belongs_to :product
  has_one :integration, inverse_of: :destination
  belongs_to :credential
end