class SalesforceObject < ActiveRecord::Base

  belongs_to :mapping
  has_many :salesforce_fields, dependent: :destroy
  accepts_nested_attributes_for :salesforce_fields, allow_destroy: true

end
