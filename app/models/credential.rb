class Credential < ActiveRecord::Base

  belongs_to :user
  belongs_to :product

  validates_presence_of :api_key

end
