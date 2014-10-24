class OdkField < ActiveRecord::Base
  belongs_to :odk_form
  has_many :odk_field_salesforce_fields
  has_many :salesforce_fields, through: :odk_field_salesforce_fields

  accepts_nested_attributes_for :salesforce_fields

  validates :is_uuid, uniqueness: true, if: :is_uuid
end
