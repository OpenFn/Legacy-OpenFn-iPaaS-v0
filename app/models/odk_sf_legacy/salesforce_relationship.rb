class OdkSfLegacy::SalesforceRelationship < ActiveRecord::Base
  belongs_to :salesforce_object
  belongs_to :salesforce_field
end
