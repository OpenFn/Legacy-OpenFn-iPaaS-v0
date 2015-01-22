class OdkSfLegacy::SalesforceField < ActiveRecord::Base
  belongs_to :salesforce_object

  has_many :odk_field_salesforce_fields, dependent: :destroy
  has_many :odk_fields, through: :odk_field_salesforce_fields

  has_one :salesforce_relationship

  def required
    !!nillable
  end

end
