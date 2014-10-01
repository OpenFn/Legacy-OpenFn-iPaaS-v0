class SalesforceField < ActiveRecord::Base
  include OdkDataConverter

  belongs_to :salesforce_object

  has_many :odk_field_salesforce_fields, dependent: :destroy
  has_many :odk_fields, through: :odk_field_salesforce_fields

  attr_accessor :import_value

end
