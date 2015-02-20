class OdkSfLegacy::OdkFieldSalesforceField < ActiveRecord::Base
  self.table_name = "legacy_odk_field_salesforce_fields" 
  
  belongs_to :odk_field
  belongs_to :salesforce_field
end
