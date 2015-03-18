class ConnectionProfile < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :credential
  belongs_to :user

  belongs_to :product

  validates_presence_of :name, :type, :product_id, :user_id, :credential_id
  validates_inclusion_of :type, in: %w(source destination)

  scope :source, -> (user_id) { where(type: 'source', user_id: user_id) }
  scope :destination, -> (user_id) { where(type: 'destination', user_id: user_id) }
end
