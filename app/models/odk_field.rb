class OdkField < ActiveRecord::Base
  belongs_to :odk_form
  has_many :odk_field_salesforce_fields
  has_many :salesforce_fields, through: :odk_field_salesforce_fields
end
