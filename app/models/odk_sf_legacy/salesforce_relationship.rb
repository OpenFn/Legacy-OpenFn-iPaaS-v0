class OdkSfLegacy::SalesforceRelationship < ActiveRecord::Base
  self.table_name = "legacy_salesforce_relationships" 
  
  belongs_to :salesforce_object
  belongs_to :salesforce_field
end
