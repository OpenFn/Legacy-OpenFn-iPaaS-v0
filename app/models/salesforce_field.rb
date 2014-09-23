class SalesforceField < ActiveRecord::Base

  belongs_to :salesforce_object

  has_many :odk_field_salesforce_fields
  has_many :odk_fields, through: :odk_field_salesforce_fields

end
